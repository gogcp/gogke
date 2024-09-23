# Internal Developer Platform (IDP)

## Google Cloud Platform projects

- [gogke-main](https://console.cloud.google.com/home/dashboard?project=gogke-main-0)
- [gogke-test](https://console.cloud.google.com/home/dashboard?project=gogke-test-0)
- [gogke-prod](https://console.cloud.google.com/home/dashboard?project=gogke-prod-0)

```
$ gcloud config set project "gogke-main-0"
```

## Terraform state buckets

- [gogke-main-0-tfstate](https://console.cloud.google.com/storage/browser/gogke-main-0-tfstate?project=gogke-main-0)

## Docker images registries

- [europe-central2-docker.pkg.dev/gogke-main-0/public-docker-images](https://console.cloud.google.com/artifacts/docker/gogke-main-0/europe-central2/public-docker-images?project=gogke-main-0)
- [europe-central2-docker.pkg.dev/gogke-main-0/private-docker-images](https://console.cloud.google.com/artifacts/docker/gogke-main-0/europe-central2/private-docker-images?project=gogke-main-0)

```
$ gcloud auth configure-docker "europe-central2-docker.pkg.dev"
```

## Helm charts registries

- [oci://europe-central2-docker.pkg.dev/gogke-main-0/public-helm-charts](https://console.cloud.google.com/artifacts/docker/gogke-main-0/europe-central2/public-helm-charts?project=gogke-main-0)
- [oci://europe-central2-docker.pkg.dev/gogke-main-0/private-helm-charts](https://console.cloud.google.com/artifacts/docker/gogke-main-0/europe-central2/private-helm-charts?project=gogke-main-0)

```
$ gcloud auth application-default print-access-token | helm registry login --username="oauth2accesstoken" --password-stdin "europe-central2-docker.pkg.dev"
```

## Terraform submodules registries

- [gogke-main-0-public-terraform-modules](https://console.cloud.google.com/storage/browser/gogke-main-0-public-terraform-modules?project=gogke-main-0)
- [gogke-main-0-private-terraform-modules](https://console.cloud.google.com/storage/browser/gogke-main-0-private-terraform-modules?project=gogke-main-0)
