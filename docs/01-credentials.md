# Credentials

## Google Cloud Platform

Login...

```
$ gcloud auth login
$ gcloud auth application-default login
$ gcloud config set account "...@gmail.com"
```

...or create [a service account key](https://cloud.google.com/iam/docs/keys-create-delete)
and export it as an environment variable:

```
$ export GOOGLE_CREDENTIALS="..."
```
