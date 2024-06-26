// Code generated by cue get go. DO NOT EDIT.

//cue:generate cue get go knative.dev/pkg/apis/duck/v1

package v1

// KReference contains enough information to refer to another object.
// It's a trimmed down version of corev1.ObjectReference.
#KReference: {
	// Kind of the referent.
	// More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds
	kind: string @go(Kind)

	// Namespace of the referent.
	// More info: https://kubernetes.io/docs/concepts/overview/working-with-objects/namespaces/
	// This is optional field, it gets defaulted to the object holding it if left out.
	// +optional
	namespace?: string @go(Namespace)

	// Name of the referent.
	// More info: https://kubernetes.io/docs/concepts/overview/working-with-objects/names/#names
	name: string @go(Name)

	// API version of the referent.
	// +optional
	apiVersion?: string @go(APIVersion)

	// Group of the API, without the version of the group. This can be used as an alternative to the APIVersion, and then resolved using ResolveGroup.
	// Note: This API is EXPERIMENTAL and might break anytime. For more details: https://github.com/knative/eventing/issues/5086
	// +optional
	group?: string @go(Group)

	// Address points to a specific Address Name.
	// +optional
	address?: null | string @go(Address,*string)
}

_#isGroupAllowed: {}
