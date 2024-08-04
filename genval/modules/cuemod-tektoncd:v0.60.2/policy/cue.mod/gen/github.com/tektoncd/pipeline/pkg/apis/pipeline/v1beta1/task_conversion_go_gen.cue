// Code generated by cue get go. DO NOT EDIT.

//cue:generate cue get go github.com/tektoncd/pipeline/pkg/apis/pipeline/v1beta1

package v1beta1

#TaskDeprecationsAnnotationKey: "tekton.dev/v1beta1.task-deprecations"
_#resourcesAnnotationKey:       "tekton.dev/v1beta1Resources"

// taskDeprecation contains deprecated fields of a Task
// +k8s:openapi-gen=false
_#taskDeprecation: {
	// DeprecatedSteps contains Steps of a Task that with deprecated fields defined.
	// +listType=atomic
	deprecatedSteps?: [...#Step] @go(DeprecatedSteps,[]Step)

	// DeprecatedStepTemplate contains stepTemplate of a Task that with deprecated fields defined.
	deprecatedStepTemplate?: null | #StepTemplate @go(DeprecatedStepTemplate,*StepTemplate)
}

// taskDeprecations contains deprecated fields of Tasks that belong to the same Pipeline or PipelineRun
// the key is Task name
// +k8s:openapi-gen=false
_#taskDeprecations: {[string]: _#taskDeprecation}