package main

import (
	"fmt"
	"log"
	"os"
	"path"

	"github.com/damlys/gogcp/go/internal/monorepo"
	"github.com/damlys/gogcp/go/internal/tmpl"
)

func main() {
	wd, err := os.Getwd()
	if err != nil {
		panic(fmt.Errorf("working directory get error: %v", err))
	}
	log.Printf("working directory: %s\n", wd)

	projects, err := monorepo.ListProjects(wd)
	if err != nil {
		panic(fmt.Errorf("projects list error: %v", err))
	}
	log.Printf("projects count: %d\n", len(projects))

	for _, p := range projects {
		log.Printf("rendering: %s\n", p.ProjectPath)
		if err := renderWorkflow(wd, p); err != nil {
			panic(fmt.Errorf("workflow render error (%s): %v", p.WorkflowFilename, err))
		}
	}

	log.Print("done!\n")
}

func renderWorkflow(wd string, project monorepo.Project) error {
	err := tmpl.RenderTemplate(
		path.Join(wd, ".github", "workflow.yaml.gotmpl"),
		path.Join(wd, ".github", "workflows", fmt.Sprintf("%s.gotmpl.yaml", project.WorkflowFilename)),
		project,
	)
	if err != nil {
		return fmt.Errorf("template render error (%s): %v", project.WorkflowFilename, err)
	}

	return nil
}
