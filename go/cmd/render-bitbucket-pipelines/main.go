package main

import (
	"fmt"
	"os"
	"strings"
	"text/template"
)

func main() {
	projects := struct {
		DockerImages        []string
		HelmCharts          []string
		HelmReleases        []string
		KubernetesManifests []string
		TerraformModules    []string
		TerraformSubmodules []string
	}{
		DockerImages:        listDirs("./docker-images"),
		HelmCharts:          listDirs("./helm-charts"),
		HelmReleases:        listDirs("./helm-releases"),
		KubernetesManifests: listDirs("./kubernetes-manifests"),
		TerraformModules:    listDirs("./terraform-modules"),
		TerraformSubmodules: listDirs("./terraform-submodules"),
	}
	templateFilePath := "bitbucket-pipelines.yml.gotmpl"
	outputFilePath := "bitbucket-pipelines.yml"

	funcMap := template.FuncMap{
		"hasPrefix": strings.HasPrefix,
		"hasSuffix": strings.HasSuffix,
		"list":      func(args ...interface{}) []interface{} { return args },
	}
	templateFile, err := template.New(templateFilePath).Funcs(funcMap).ParseFiles(templateFilePath)
	if err != nil {
		panic(fmt.Errorf("template parse error: %v", err))
	}

	outputFile, err := os.Create(outputFilePath)
	if err != nil {
		panic(fmt.Errorf("file create error: %v", err))
	}

	err = templateFile.Execute(outputFile, projects)
	if err != nil {
		panic(fmt.Errorf("template execute error: %v", err))
	}
}

func listDirs(path string) []string {
	files, err := os.ReadDir(path)
	if err != nil {
		panic(fmt.Errorf("read dir error (%s): %v", path, err))
	}

	var dirs []string
	for _, f := range files {
		if f.IsDir() && !strings.HasPrefix(f.Name(), ".") {
			dirs = append(dirs, f.Name())
		}
	}
	return dirs
}
