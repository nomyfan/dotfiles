"""List all available tools from an MCP server."""

import argparse
import asyncio
import json
import sys

from pathlib import Path

from httpx import AsyncClient
from mcp import ClientSession
from mcp.client.streamable_http import streamable_http_client


def load_headers(headers_file: Path | None) -> dict:
    """Load headers from the specified JSON file, or return empty dict if none provided."""
    if headers_file is None:
        return {}

    if not headers_file.exists():
        print(f"Error: Headers file not found: {headers_file}", file=sys.stderr)
        sys.exit(1)

    try:
        with open(headers_file) as f:
            return json.load(f)
    except json.JSONDecodeError:
        print(f"Error: {headers_file} is not valid JSON", file=sys.stderr)
        sys.exit(1)


async def list_mcp_tools(mcp_url: str, headers: dict) -> None:
    """List all tools available on the MCP server."""
    async with AsyncClient(headers=headers) as httpx_client:
        async with streamable_http_client(
            mcp_url,
            http_client=httpx_client,
        ) as (read_stream, write_stream, _):
            async with ClientSession(read_stream, write_stream) as session:
                await session.initialize()
                result = await session.list_tools()

                tools = []
                for tool in result.tools:
                    tool_info = {
                        "name": tool.name,
                        "description": tool.description,
                        "parameters": tool.inputSchema,
                    }
                    tools.append(tool_info)

                print(json.dumps(tools, indent=2))


async def main():
    parser = argparse.ArgumentParser(
        description="List all available tools from an MCP server."
    )
    parser.add_argument("mcp_url", help="MCP server URL")
    parser.add_argument(
        "--headers",
        type=Path,
        required=False,
        help="Path to JSON file containing request headers (optional for public servers)",
    )

    args = parser.parse_args()

    headers = load_headers(args.headers)
    await list_mcp_tools(args.mcp_url, headers)


if __name__ == "__main__":
    asyncio.run(main())
