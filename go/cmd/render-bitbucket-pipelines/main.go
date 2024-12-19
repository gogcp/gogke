package main

import (
	"fmt"
	"log"
	"os"
	"strings"

	"github.com/damlys/gogcp/go/internal/tmpl"
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
	templateFilePath := "./bitbucket-pipelines.yml.gotmpl"
	outputFilePath := "./bitbucket-pipelines.yml"

	err := tmpl.RenderTemplate(templateFilePath, outputFilePath, projects)
	if err != nil {
		panic(fmt.Errorf("template render error: %v", err))
	}

	log.Print("done!\n")
}

func listDirs(path string) []string {
	files, err := os.ReadDir(path)
	if err != nil {
		panic(fmt.Errorf("dir read error (%s): %v", path, err))
	}

	var dirs []string
	for _, f := range files {
		if f.IsDir() && !strings.HasPrefix(f.Name(), ".") {
			dirs = append(dirs, f.Name())
		}
	}
	return dirs
}
