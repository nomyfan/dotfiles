import argparse
import asyncio
import json
import sys

from httpx import AsyncClient
from mcp import ClientSession
from mcp.client.streamable_http import streamable_http_client


MCP_URL = "<mcp-server-url>"


async def invoke_mcp_tool(tool_name: str, params: dict) -> None:
    async with AsyncClient() as httpx_client:
        async with streamable_http_client(MCP_URL, http_client=httpx_client) as (
            read_stream,
            write_stream,
            _,
        ):
            async with ClientSession(read_stream, write_stream) as session:
                await session.initialize()
                result = await session.call_tool(tool_name, arguments=params)
                print(result)


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Invoke <skill-name> MCP tools.")
    parser.add_argument("tool_name", help="Name of the MCP tool to invoke")
    parser.add_argument(
        "params_json",
        nargs="?",
        default="{}",
        help="JSON string of parameters (default: {})",
    )
    return parser.parse_args()


async def main() -> None:
    args = parse_args()
    try:
        params = json.loads(args.params_json)
    except json.JSONDecodeError:
        print("Error: params_json must be valid JSON.", file=sys.stderr)
        sys.exit(1)
    await invoke_mcp_tool(args.tool_name, params)


if __name__ == "__main__":
    asyncio.run(main())
