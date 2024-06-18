// Code generated by cue get go. DO NOT EDIT.

//cue:generate cue get go k8s.io/api/networking/v1alpha1

package v1alpha1

import metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"

// IPAddress represents a single IP of a single IP Family. The object is designed to be used by APIs
// that operate on IP addresses. The object is used by the Service core API for allocation of IP addresses.
// An IP address can be represented in different formats, to guarantee the uniqueness of the IP,
// the name of the object is the IP address in canonical format, four decimal digits separated
// by dots suppressing leading zeros for IPv4 and the representation defined by RFC 5952 for IPv6.
// Valid: 192.168.1.5 or 2001:db8::1 or 2001:db8:aaaa:bbbb:cccc:dddd:eeee:1
// Invalid: 10.01.2.3 or 2001:db8:0:0:0::1
#IPAddress: {
	metav1.#TypeMeta

	// Standard object's metadata.
	// More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#metadata
	// +optional
	metadata?: metav1.#ObjectMeta @go(ObjectMeta) @protobuf(1,bytes,opt)

	// spec is the desired state of the IPAddress.
	// More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#spec-and-status
	// +optional
	spec?: #IPAddressSpec @go(Spec) @protobuf(2,bytes,opt)
}

// IPAddressSpec describe the attributes in an IP Address.
#IPAddressSpec: {
	// ParentRef references the resource that an IPAddress is attached to.
	// An IPAddress must reference a parent object.
	// +required
	parentRef?: null | #ParentReference @go(ParentRef,*ParentReference) @protobuf(1,bytes,opt)
}

// ParentReference describes a reference to a parent object.
#ParentReference: {
	// Group is the group of the object being referenced.
	// +optional
	group?: string @go(Group) @protobuf(1,bytes,opt)

	// Resource is the resource of the object being referenced.
	// +required
	resource?: string @go(Resource) @protobuf(2,bytes,opt)

	// Namespace is the namespace of the object being referenced.
	// +optional
	namespace?: string @go(Namespace) @protobuf(3,bytes,opt)

	// Name is the name of the object being referenced.
	// +required
	name?: string @go(Name) @protobuf(4,bytes,opt)
}

// IPAddressList contains a list of IPAddress.
#IPAddressList: {
	metav1.#TypeMeta

	// Standard object's metadata.
	// More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#metadata
	// +optional
	metadata?: metav1.#ListMeta @go(ListMeta) @protobuf(1,bytes,opt)

	// items is the list of IPAddresses.
	items: [...#IPAddress] @go(Items,[]IPAddress) @protobuf(2,bytes,rep)
}

// ServiceCIDR defines a range of IP addresses using CIDR format (e.g. 192.168.0.0/24 or 2001:db2::/64).
// This range is used to allocate ClusterIPs to Service objects.
#ServiceCIDR: {
	metav1.#TypeMeta

	// Standard object's metadata.
	// More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#metadata
	// +optional
	metadata?: metav1.#ObjectMeta @go(ObjectMeta) @protobuf(1,bytes,opt)

	// spec is the desired state of the ServiceCIDR.
	// More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#spec-and-status
	// +optional
	spec?: #ServiceCIDRSpec @go(Spec) @protobuf(2,bytes,opt)

	// status represents the current state of the ServiceCIDR.
	// More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#spec-and-status
	// +optional
	status?: #ServiceCIDRStatus @go(Status) @protobuf(3,bytes,opt)
}

// ServiceCIDRSpec define the CIDRs the user wants to use for allocating ClusterIPs for Services.
#ServiceCIDRSpec: {
	// CIDRs defines the IP blocks in CIDR notation (e.g. "192.168.0.0/24" or "2001:db8::/64")
	// from which to assign service cluster IPs. Max of two CIDRs is allowed, one of each IP family.
	// This field is immutable.
	// +optional
	// +listType=atomic
	cidrs?: [...string] @go(CIDRs,[]string) @protobuf(1,bytes,opt)
}

// ServiceCIDRConditionReady represents status of a ServiceCIDR that is ready to be used by the
// apiserver to allocate ClusterIPs for Services.
#ServiceCIDRConditionReady: "Ready"

// ServiceCIDRReasonTerminating represents a reason where a ServiceCIDR is not ready because it is
// being deleted.
#ServiceCIDRReasonTerminating: "Terminating"

// ServiceCIDRStatus describes the current state of the ServiceCIDR.
#ServiceCIDRStatus: {
	// conditions holds an array of metav1.Condition that describe the state of the ServiceCIDR.
	// Current service state
	// +optional
	// +patchMergeKey=type
	// +patchStrategy=merge
	// +listType=map
	// +listMapKey=type
	conditions?: [...metav1.#Condition] @go(Conditions,[]metav1.Condition) @protobuf(1,bytes,rep)
}

// ServiceCIDRList contains a list of ServiceCIDR objects.
#ServiceCIDRList: {
	metav1.#TypeMeta

	// Standard object's metadata.
	// More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#metadata
	// +optional
	metadata?: metav1.#ListMeta @go(ListMeta) @protobuf(1,bytes,opt)

	// items is the list of ServiceCIDRs.
	items: [...#ServiceCIDR] @go(Items,[]ServiceCIDR) @protobuf(2,bytes,rep)
}
