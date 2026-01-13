---
name: mcp-skill-creator
description: Generate skills from MCP (Model Context Protocol) server tools. Use when the user wants to create a skill based on MCP tools, wrap MCP server functionality into a skill, or generate SKILL.md from MCP tool definitions. Triggers on requests like "create a skill for the X MCP server" or "generate a skill from MCP tools".
---

# MCP Skill Creator

Generate skills by analyzing MCP server tools and creating appropriate SKILL.md files with workflows.

## Process

### 1. Get MCP Server Details

Ask the user for:

- **MCP server URL** (e.g., `https://mcp.example.com/mcp`)
- **Authentication type**: Does this server require authentication?
  - If **yes**: Ask for headers file path containing a JSON object (e.g., `{"Authorization": "Bearer ...", "X-API-Key": "..."}`)
  - If **no**: Server is public, no headers needed

### 2. Discover Available Tools

Run the `list_mcp_tools.py` script to fetch all tools from the MCP server:

**For authenticated servers:**

```bash
python3 scripts/list_mcp_tools.py <mcp_url> --headers <path-to-headers-file>
```

**For public servers:**

```bash
python3 scripts/list_mcp_tools.py <mcp_url>
```

The script outputs JSON with tool definitions:

```json
[
  {
    "name": "tool-name",
    "description": "What the tool does",
    "parameters": { "type": "object", "properties": {...}, "required": [...] }
  }
]
```

### 3. Analyze Tool Relationships

Group tools by function:

- **Query tools**: Read/fetch data
- **Mutation tools**: Create/modify/delete
- **Utility tools**: Helpers, validation, formatting

**Analyze tool relationships:**
- **Workflow patterns**: Tools with dependencies (e.g., "resolve ID → query data")
- **Independent tools**: Standalone operations with no dependencies
- **Parallel tools**: Related but independent operations (e.g., get-current, get-forecast)

Check tool descriptions and parameters to identify if tools naturally form chains or operate independently.

### 4. Generate Skill Structure

Create the skill directory structure:

```
skills/<skill-name>/
  SKILL.md
  scripts/
    invoke_mcp.py
```

#### Understand Invoke Script Parameters

The `invoke_mcp.py` script has different parameters based on authentication requirements:

**Authenticated servers:**
```bash
python3 scripts/invoke_mcp.py <tool_name> [params_json] --headers-file <path>
```

**Public servers:**
```bash
python3 scripts/invoke_mcp.py <tool_name> [params_json]
```

**Parameters:**
- `tool_name` (required): Name of the MCP tool to invoke
- `params_json` (optional): JSON string with tool parameters, defaults to `{}`
- `--headers-file` (required for auth): Path to JSON file containing authentication headers

When documenting tools in SKILL.md, include the appropriate format based on server type.

#### Generate SKILL.md

Create frontmatter:

```yaml
---
name: <server-name>
description: <comprehensive description of capabilities and when to use>
---
```

Structure the body:

1. **Add Script Usage section** (required for all skills):

   Document the invoke_mcp.py script parameters before tool documentation.

   **For authenticated servers:**
   ````markdown
   ## Script Usage

   **Command format:**
   \```bash
   python3 scripts/invoke_mcp.py <tool_name> [params_json] --headers-file <headers-file>
   \```

   **Parameters:**
   - `tool_name` (required): MCP tool name to invoke
   - `params_json` (optional): JSON string with tool parameters (default: `{}`)
   - `--headers-file` (required): Path to authentication headers JSON file
   ````

   **For public servers:**
   ````markdown
   ## Script Usage

   **Command format:**
   \```bash
   python3 scripts/invoke_mcp.py <tool_name> [params_json]
   \```

   **Parameters:**
   - `tool_name` (required): MCP tool name to invoke
   - `params_json` (optional): JSON string with tool parameters (default: `{}`)
   ````

2. **Organize tool documentation** based on tool analysis:
   - **Few tools (1-3)**: Task-based with examples for each
   - **Related tools**: Workflow-based showing tool chains
   - **Many tools**: Capabilities-based with categories

#### Generate Invoke Script

Create `scripts/invoke_mcp.py` by copying the appropriate template:

**For authenticated servers** - Use `assets/invoke_mcp_auth.py`:

1. Copy the template to the new skill's scripts directory as `invoke_mcp.py`
2. Replace `<mcp-server-url>` with the actual MCP server URL
3. Replace `<skill-name>` in the parser description with the actual skill name

The template provides:

- Argument parsing: `tool_name`, `params_json`, `--headers-file` (required)
- Headers loading from JSON file
- MCP client connection and tool invocation
- Error handling for invalid JSON and missing files

**For public servers** - Use `assets/invoke_mcp_public.py`:

1. Copy the template to the new skill's scripts directory as `invoke_mcp.py`
2. Replace `<mcp-server-url>` with the actual MCP server URL
3. Replace `<skill-name>` in the parser description with the actual skill name

The template provides:

- Argument parsing: `tool_name`, `params_json` (no headers parameter)
- MCP client connection and tool invocation
- Error handling for invalid JSON

### 5. Document Each Tool in SKILL.md

**Analyze tool relationships and document accordingly:**

A single MCP server may contain both dependent and independent tools. Document each appropriately:

- **Dependent tools**: Tools that form a workflow (e.g., output of Tool A is input to Tool B) → Document as a workflow section with sequential steps
- **Independent tools**: Standalone tools with no dependencies → Document in separate sections with individual purposes

The same SKILL.md can contain both workflow sections and independent tool sections.

**For each tool, provide:**
- Tool purpose and name
- Parameter list with required/optional indicators
- Basic usage format
- **One representative example** showing common use case

**For authenticated servers:**

````markdown
## <Tool Purpose>

**Tool**: `<tool-name>`

**Parameters**:
- `param1` (required): Description
- `param2` (optional): Description, default: X

**Usage**:
\```bash
python3 scripts/invoke_mcp.py <tool-name> '[params_json]' --headers-file <headers-file>
\```

**Example**:
\```bash
python3 scripts/invoke_mcp.py <tool-name> '{"param1": "value", "param2": "value"}' --headers-file <headers-file>
\```
````

**For public servers:**

````markdown
## <Tool Purpose>

**Tool**: `<tool-name>`

**Parameters**:
- `param1` (required): Description
- `param2` (optional): Description, default: X

**Usage**:
\```bash
python3 scripts/invoke_mcp.py <tool-name> '[params_json]'
\```

**Example**:
\```bash
python3 scripts/invoke_mcp.py <tool-name> '{"param1": "value", "param2": "value"}'
\```
````

## Example Output Structures

### Example 1: Authenticated Server

For an authenticated MCP server, the generated structure would be:

**Directory Structure**:

```
skills/weather-pro/
  SKILL.md
  scripts/
    invoke_mcp.py
```

**SKILL.md**:

````markdown
---
name: weather-pro
description: Get current weather and forecasts from premium weather service. Use when user asks about weather conditions, temperature, or forecasts for any location.
---

# Weather Pro Service

Get weather data for any location worldwide with premium features.

## Script Usage

**Command format:**
```bash
python3 scripts/invoke_mcp.py <tool_name> [params_json] --headers-file <headers-file>
```

**Parameters:**
- `tool_name` (required): MCP tool name to invoke
- `params_json` (optional): JSON string with tool parameters (default: `{}`)
- `--headers-file` (required): Path to authentication headers JSON file

## Get Current Weather

**Tool**: `get-current-weather`

**Parameters**:

- `location` (required): City name or coordinates
- `units` (optional): Temperature units (celsius/fahrenheit), default: celsius

**Usage**:

```bash
python3 scripts/invoke_mcp.py get-current-weather '{"location": "San Francisco"}' --headers-file weather-headers.json
```
````

### Example 2: Public Server

For a public MCP server (no authentication required):

**Directory Structure**:

```
skills/weather/
  SKILL.md
  scripts/
    invoke_mcp.py
```

**SKILL.md**:

````markdown
---
name: weather
description: Get current weather and forecasts. Use when user asks about weather conditions, temperature, or forecasts for any location.
---

# Weather Service

Get weather data for any location worldwide.

## Script Usage

**Command format:**
```bash
python3 scripts/invoke_mcp.py <tool_name> [params_json]
```

**Parameters:**
- `tool_name` (required): MCP tool name to invoke
- `params_json` (optional): JSON string with tool parameters (default: `{}`)

## Get Current Weather

**Tool**: `get-current-weather`

**Parameters**:

- `location` (required): City name or coordinates
- `units` (optional): Temperature units (celsius/fahrenheit), default: celsius

**Usage**:

```bash
python3 scripts/invoke_mcp.py get-current-weather '{"location": "San Francisco"}'
```
````

## Guidelines

- Keep descriptions actionable and trigger-focused
- **Include exactly one concrete example per tool** - choose the most representative use case
- **Document based on actual tool relationships:**
  - If tools have dependencies, document as a workflow with sequential steps
  - If tools are independent, document them separately with clear individual purposes
  - Base documentation structure on tool descriptions and parameter dependencies, not assumptions
- Omit obvious parameter descriptions (e.g., "query: the query string")
- Focus on what users accomplish, not tool mechanics
- Choose the appropriate template (auth vs public) based on server requirements
- In Usage sections, show the parameter format: `[params_json]` for clarity
