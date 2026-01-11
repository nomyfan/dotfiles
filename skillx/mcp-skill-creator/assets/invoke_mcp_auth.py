import argparse
import asyncio
import json
import sys

from pathlib import Path

from httpx import AsyncClient
from mcp import ClientSession
from mcp.client.streamable_http import streamable_http_client


MCP_URL = "<mcp-server-url>"


def load_headers(config_path: Path) -> dict:
    """Load headers from a JSON config file."""
    if not config_path.exists():
        print(f"Error: headers file {config_path} not found.", file=sys.stderr)
        sys.exit(1)

    try:
        with open(config_path) as f:
            return json.load(f)
    except json.JSONDecodeError:
        print(f"Error: {config_path} is not valid JSON.", file=sys.stderr)
        sys.exit(1)


async def invoke_mcp_tool(tool_name: str, params: dict, headers: dict) -> None:
    async with AsyncClient(headers=headers) as httpx_client:
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
    parser.add_argument(
        "--headers-file",
        type=Path,
        required=True,
        help="Path to JSON file containing MCP headers",
    )
    return parser.parse_args()


async def main() -> None:
    args = parse_args()
    try:
        params = json.loads(args.params_json)
    except json.JSONDecodeError:
        print("Error: params_json must be valid JSON.", file=sys.stderr)
        sys.exit(1)
    headers = load_headers(args.headers_file)
    await invoke_mcp_tool(args.tool_name, params, headers)


if __name__ == "__main__":
    asyncio.run(main())
