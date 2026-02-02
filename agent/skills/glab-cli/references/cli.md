# glab CLI Reference (short)

## Official Docs
- Main docs: https://docs.gitlab.com/cli/
- Auth login: https://docs.gitlab.com/cli/auth/login/
- Config: https://docs.gitlab.com/cli/config/
- Issue: https://docs.gitlab.com/cli/issue/
- Issue create: https://docs.gitlab.com/cli/issue/create/
- Issue view: https://docs.gitlab.com/cli/issue/view/
- MR: https://docs.gitlab.com/cli/mr/
- MR create: https://docs.gitlab.com/cli/mr/create/
- MR merge: https://docs.gitlab.com/cli/mr/merge/
- CI: https://docs.gitlab.com/cli/ci/
- API: https://docs.gitlab.com/cli/api/
- Release create: https://docs.gitlab.com/cli/release/create/

## Authentication
- `glab auth login` for interactive auth.
- Use `--stdin` to pass a token via stdin.
- Minimum token scopes: `api`, `write_repository`.
- Config path: `~/.config/glab-cli/config.yml`.
- In a Git repo, glab can detect GitLab hosts from git remotes.
- For self-managed or dedicated, pass `--hostname` or set `host` in config.
- If a token is required and `GITLAB_API_TOKEN` is set, prefer it over `GITLAB_TOKEN`.

## Config (key/value)
- `glab config set <key> <value>` / `glab config get <key>`.
- Keys: `browser`, `check_update`, `display_hyperlinks`, `editor`, `glab_pager`, `glamour_style`, `host`, `token`, `visual`.

## Environment Variables (common)
- `BROWSER`: browser for links (config: `glab config set browser <cmd>`)
- `EDITOR` / `VISUAL`: editor used by glab
- `DEBUG`: verbose logging
- `FORCE_HYPERLINKS`: force hyperlink output
- `GITLAB_HOST` or `GL_HOST`: GitLab host URL (default `https://gitlab.com`)
- `GITLAB_API_TOKEN`: preferred API token (if set)
- `GITLAB_TOKEN`: fallback API token to avoid interactive auth

## Issues (examples)
- List: `glab issue list`
- Create: `glab issue create -t "title" -d "desc" -l label`
- View: `glab issue view 123` or `glab issue view --web 123`
- Comment: `glab issue note -m "message" 123`

## Merge Requests (examples)
- Create: `glab mr create --fill` or `glab mr create -t "title" -d "desc"`
- Draft: `glab mr create --draft` (or `--wip`)
- Link issue: `glab mr create --related-issue <issue>`
- Merge: `glab mr merge 123` (alias: `accept`)
- View: `glab mr view 123`
- List: `glab mr list --assignee=@me`

## CI/CD
- `glab ci` works with pipelines and jobs.
- Aliases: `pipeline`, `pipe`.

## API
- `glab api <endpoint>` for REST v4, `glab api graphql` for GraphQL.
- Host selection: use current repo's authenticated host, or `--hostname`.
- Placeholders: `:branch`, `:fullpath`, `:group`, `:id`, `:namespace`, `:repo`, `:user`, `:username`.
- Default method is `GET` when no params, `POST` otherwise. Override with `--method`.
- `--field` / `--raw-field` for JSON body; `@file` to read from file; `-` for stdin.
- `--paginate` fetches all pages sequentially.

## Releases
- `glab release create <tag>` creates/updates a release.
- If tag does not exist, it creates from default branch and tags it.
- Use `--ref` to specify a commit SHA, tag, or branch to override.

## Notes
- Always run `glab <command> --help` for latest flags/options.
- Prefer `-R/--repo` when working outside a repo, or when targeting a different project.
