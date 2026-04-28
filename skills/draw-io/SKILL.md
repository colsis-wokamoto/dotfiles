---
name: draw-io
description: draw.io diagram creation, editing, and review for architecture and workflow communication. Use for .drawio XML editing, Mermaid/CSV/XML generation, PNG conversion, layout adjustment, and AWS architecture diagram production with official icon usage. If drawio-mcp-server is available, use it first to open and refine Mermaid/CSV/XML directly in draw.io.
---

# draw.io Diagram Skill

## 1. Workflow

1. Clarify purpose, audience, and required detail.
2. Decide diagram type and whether to split into multiple diagrams.
3. Define node list and connection list before editing layout.
4. Choose format: Mermaid, CSV, or `.drawio` XML.
5. Generate diagram, then fix layout/readability issues.
6. Export PNG and visually verify overlap, spacing, and directionality.

## 2. drawio-mcp-server Usage

If drawio-mcp-server is available, use it first.

- `mcp__drawio-mcp-server__open_drawio_mermaid`
  - Use for flow/architecture/dependency diagrams.
- `mcp__drawio-mcp-server__open_drawio_csv`
  - Use for org charts or table-driven diagrams.
- `mcp__drawio-mcp-server__open_drawio_xml`
  - Use for direct `.drawio` XML edits and fine tuning.

If MCP is unavailable, output Mermaid or draw.io XML and provide manual import/edit steps.

## 3. Basic Rules

- Edit `.drawio` files directly.
- Do not manually edit generated `.drawio.png`.
- Prefer transparent backgrounds for portability.
- Keep style consistent: font, icon size, line width, arrow style.

## 4. AWS Icons and Service Names

AWS icon retrieval and naming must follow existing draw-io rules.

- Always use `mxgraph.aws4.*` icons (avoid `aws3`).
- Always use official service names (for example `Amazon ECS`, not `ECS`).
- Use this reference as source of truth: `references/aws-icons.md`.
- Search icons with the bundled script before writing styles:

```sh
python draw-io/scripts/find_aws_icon.py ec2
python scripts/find_aws_icon.py lambda
```

### Tips for AWS Icons

When using AWS resource icons, the following style pattern ensures visibility and consistency (white-bordered style):

- **Style Pattern:** `sketch=0;outlineConnect=0;fontColor=#232F3E;fillColor=#COLOR;strokeColor=#ffffff;dashed=0;verticalLabelPosition=bottom;verticalAlign=top;align=center;html=1;fontSize=12;fontStyle=0;aspect=fixed;shape=mxgraph.aws4.resourceIcon;resIcon=mxgraph.aws4.ICON_NAME;`
- **Specific Color Examples:**
  - WAF: `fillColor=#DD344C` (Red)
  - ALB/NLB: `fillColor=#8C4FFF` (Purple)
  - EC2: `fillColor=#F58534` (Orange)
  - RDS: `fillColor=#3334B9` (Blue)
  - S3: `fillColor=#7AA116` (Green; use `resIcon=mxgraph.aws4.s3` — **not** `s3_bucket` — or the icon may not render)
  - VPC Peering: `fillColor=#7AA116` (Green)
- **Search Terms:** If "alb" or "nlb" fail, try searching for "load balancer". If "bastion" fails, use "instance2" for EC2.

### Resolving icon display issues

If an AWS icon does not render in draw.io:

1. **Use the correct resIcon:** For S3 use `resIcon=mxgraph.aws4.s3` (not `s3_bucket`). See `references/aws-icons.md` §5.5 for details.
2. **Copy from a working diagram:** In the same project, find another `.drawio` where the icon displays correctly. Grep for that cell’s `style` and copy the same `shape=` / `resIcon=` into your diagram.
3. **Align mxfile with the reference:** Set the diagram’s `<mxfile>` `version` and `agent` to match the reference file (e.g. a file saved from draw.io in the browser) so the same shape libraries load.
4. **Connect edges by cell id:** Use `target="cellId"` and `source="cellId"` on edges so connections survive when cells are replaced; update these ids if you swap in new S3 (or other) cells.

### Tips for AWS Groups (Containers)

When representing infrastructure hierarchy, use the following group patterns for consistent AWS-style containers:

- **Common Attributes:** `outlineConnect=0;gradientColor=none;html=1;whiteSpace=wrap;fontSize=12;fontStyle=0;container=1;pointerEvents=0;collapsible=0;recursiveResize=0;shape=mxgraph.aws4.group;verticalAlign=top;align=left;spacingLeft=30;`
- **AWS Account Group:**
  - `shape=mxgraph.aws4.group;grIcon=mxgraph.aws4.group_account;strokeColor=#CD2264;fillColor=none;fontColor=#CD2264;dashed=0;`
- **Region Group:** 
  - `shape=mxgraph.aws4.group;grIcon=mxgraph.aws4.group_region;strokeColor=#00A4A6;fillColor=none;fontColor=#147EBA;dashed=1;`
- **VPC Group:** 
  - `shape=mxgraph.aws4.group;grIcon=mxgraph.aws4.group_vpc2;strokeColor=#8C4FFF;fillColor=none;fontColor=#AAB7B8;dashed=0;`
- **Subnet Groups (using Security Group shape for coloring):**
  - **Public Subnet:** `shape=mxgraph.aws4.group;grIcon=mxgraph.aws4.group_security_group;grStroke=0;strokeColor=#7AA116;fillColor=#F2F6E8;fontColor=#248814;`
  - **Private Subnet:** `shape=mxgraph.aws4.group;grIcon=mxgraph.aws4.group_security_group;grStroke=0;strokeColor=#00A4A6;fillColor=#E6F6F7;fontColor=#147EBA;`

### Tips for Flow and Connectivity

- **Peering:** Use `mxgraph.aws4.peering` icon placed on the connection line or between VPCs to indicate a peering relationship.
- **PrivateLink:** Use `mxgraph.aws4.vpc_privatelink` and `mxgraph.aws4.endpoints` to represent service exposure and consumption across accounts.
- **Traffic Differentiation:** Use different line styles or colors (e.g., thick flex arrows for main traffic, dashed lines for management/SSH, colored lines for data replication) to distinguish between logical flows.

## 5. Font and Text Rules

For Quarto/reveal.js usage, set both model default and per-element font.

```xml
<mxGraphModel defaultFontFamily="Noto Sans JP" ...>
```

```xml
style="text;html=1;fontSize=27;fontFamily=Noto Sans JP;"
```

- Keep readable font sizes (around 18px+ depending on output medium).
- For Japanese labels, allocate enough width to avoid accidental wrapping.

## 6. Layout and XML Tuning

- Prefer one reading direction (left-to-right or top-to-bottom).
- Minimize crossing lines.
- Use unidirectional arrows instead of one ambiguous bidirectional edge.
- Place arrows behind main nodes/text when layering in XML.
- Keep arrow labels offset from lines via `mxPoint ... as="offset"`.
- Keep at least 30px margin between container frames and internal elements.

When coordinate-tuning in XML:

1. Find target `mxCell` by `value` or `id`.
2. Adjust `mxGeometry` (`x`, `y`, `width`, `height`).
3. Re-export and visually verify.

## 7. Conversion

Use `scripts/convert-drawio-to-png.sh` or project pre-commit hooks.

```sh
mise exec -- pre-commit run --all-files
mise exec -- pre-commit run convert-drawio-to-png --files assets/my-diagram.drawio
bash scripts/convert-drawio-to-png.sh assets/diagram1.drawio
```

Underlying command:

```sh
drawio -x -f png -s 2 -t -o output.drawio.png input.drawio
```

## 8. Architecture Design Principles

- Keep one diagram focused on one primary message.
- Use layered disclosure when complexity grows:
  - Context -> System/Container -> Component/Flow.
- Label all critical components and boundaries.
- Add legend when line types/colors encode meaning.
- Remove decorative elements that do not improve understanding.

## 9. References

- `references/layout-guidelines.md`
- `references/aws-icons.md` (incl. §5.5 icon display troubleshooting: S3 resIcon, copying from project .drawio, mxfile version alignment, edge target by cell id)
- `scripts/find_aws_icon.py`
- `references/drawio-practical-guide.md`
- `references/architecture-diagram-principles.md`
- `references/source-links.md`

## 10. Checklist

- [ ] Diagram purpose and audience are explicit.
- [ ] Directional flow is easy to follow.
- [ ] Overlaps/crossings are minimized.
- [ ] AWS names and icons match official conventions.
- [ ] Font settings are explicitly configured.
- [ ] Container margins (30px+) are respected.
- [ ] PNG export is visually verified.
