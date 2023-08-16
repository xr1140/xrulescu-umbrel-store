## Umbrel Community App Store Template

This repository contains the XRulescu Umbrel App Store. This app store is a community app store that is not maintained by the Umbrel team.

## Apps

| App Name | Added         | Last Updated    | Updated By | Version |
|----------|---------------|-----------------|------------|---------|
| InfluxDB | Aug 15th 2023 | Aug 16th 2023   | XRulescu   | 0.0.1   |


### Technical Details

The `umbrel-app-store.yml` file defines two important properties:
- `id` - This is used as a prefix for all apps within the community app store. You **MUST** prefix your application id with your app store ID. For example, this template defines `sparkles` as a community app store ID and we have a `hello world` app. The app ID therefore should be: `sparkles-hello-world`
- `name` - This name appears within the Umbrel user interface when users explore apps within these community app stores.


### Testing

To test your community app store, you can add this repository through the Umbrel user interface as shown in the following demo:


https://user-images.githubusercontent.com/10330103/197889452-e5cd7e96-3233-4a09-b475-94b754adc7a3.mp4


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