// Code generated by cue get go. DO NOT EDIT.

//cue:generate cue get go github.com/argoproj/argo-cd/v2/pkg/apis/application/v1alpha1

package v1alpha1

#DefaultSyncRetryMaxDuration: int & 180000000000
#DefaultSyncRetryDuration:    int & 5000000000
#DefaultSyncRetryFactor:      int64 & 2

// ResourcesFinalizerName is the finalizer value which we inject to finalize deletion of an application
#ResourcesFinalizerName: "resources-finalizer.argocd.argoproj.io"

// PostDeleteFinalizerName is the finalizer that controls post-delete hooks execution
#PostDeleteFinalizerName: "post-delete-finalizer.argocd.argoproj.io"

// ForegroundPropagationPolicyFinalizer is the finalizer we inject to delete application with foreground propagation policy
#ForegroundPropagationPolicyFinalizer: "resources-finalizer.argocd.argoproj.io/foreground"

// BackgroundPropagationPolicyFinalizer is the finalizer we inject to delete application with background propagation policy
#BackgroundPropagationPolicyFinalizer: "resources-finalizer.argocd.argoproj.io/background"

// DefaultAppProjectName contains name of 'default' app project, which is available in every Argo CD installation
#DefaultAppProjectName: "default"

// RevisionHistoryLimit is the max number of successful sync to keep in history
#RevisionHistoryLimit: 10

// KubernetesInternalAPIServerAddr is address of the k8s API server when accessing internal to the cluster
#KubernetesInternalAPIServerAddr: "https://kubernetes.default.svc"
