## Umbrel Community App Store Template

This repository contains the XRulescu Umbrel App Store. This app store is a community app store that is not maintained by the Umbrel team.

## Apps

| App Name            | Added         | Last Updated    | Updated By | Version |
|---------------------|---------------|-----------------|------------|---------|
| InfluxDB            | Aug 15th 2023 | Aug 16th 2023   | XRulescu   | 0.0.1   |
| Graphana            | Oct 17th 2023 | Oct 17th 2023   | XRulescu   | 0.0.1   |
| Waveshare UPS Hat D | Jun 05th 2025 | Nov 10th 2026   | XRulescu   | 0.1.7   |
| Waveshare UPS Hat E | May 10th 2026 | Nov 10th 2026   | XRulescu   | 0.1.7   |
| Kanzo               | Nov 04th 2026 | Nov 04th 2026   | XRulescu   | 0.3.4   |


### Technical Details

The `umbrel-app-store.yml` file defines two important properties:
- `id` - This is used as a prefix for all apps within the community app store. You **MUST** prefix your application id with your app store ID. For example, this template defines `sparkles` as a community app store ID and we have a `hello world` app. The app ID therefore should be: `sparkles-hello-world`
- `name` - This name appears within the Umbrel user interface when users explore apps within these community app stores.


### Testing

To test your community app store, you can add this repository through the Umbrel user interface as shown in the following demo:


https://user-images.githubusercontent.com/10330103/197889452-e5cd7e96-3233-4a09-b475-94b754adc7a3.mp4


## Kanzo

[Kanzo](https://github.com/emanuele-em/kanzo) is created by
[Emanuele Micheletti](https://github.com/emanuele-em) and is licensed under
[AGPL-3.0](https://github.com/emanuele-em/kanzo/blob/main/LICENSE).

This store packages the upstream release for Umbrel. The image is built from
the pinned upstream source plus a small patch for Umbrel's reverse proxy and the
home-screen widgets; all credit for Kanzo belongs to its author.

## Kanzo MCP

Kanzo exposes its MCP server at `http://<umbrel-ip>:4242/mcp`. The board UI stays behind Umbrel's login on port `4290`; port `4242` is unauthenticated by design, so keep it on a trusted LAN or reach it over a VPN.

Claude Code:

```sh
claude mcp add --transport http --scope user kanzo http://<umbrel-ip>:4242/mcp
```

OpenCode v2:

```sh
opencode mcp add kanzo --global --url http://<umbrel-ip>:4242/mcp
```

Or use the native CLI: `kanzo join <umbrel-ip>:4242`, then point the client at `kanzo mcp` (stdio).

Check the endpoint:

```sh
curl -s -H 'Content-Type: application/json' -H 'Accept: application/json, text/event-stream' \
  -d '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-06-18","capabilities":{},"clientInfo":{"name":"test","version":"1"}}}' \
  http://<umbrel-ip>:4242/mcp
```

## CLI How to

To add an app store:

```
sudo ~/umbrel/scripts/repo add https://github.com/xr1140/xrulescu-umbrel-store.git
```

To update an app store:

```
sudo ~/umbrel/scripts/repo update
```

To install an app from the app store

```
sudo ~/umbrel/scripts/app install xrulescu-example-app
```

To remove an app store:

```
sudo ~/umbrel/scripts/repo remove https://github.com/xr1140/xrulescu-umbrel-store.git
```
