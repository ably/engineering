# Ably Engineering Team: Product Lifecycle

Two preliminary lifecycle stages - Alpha and Beta - are designed to ensure that customers can safely start testing Ably's latest technology and provide us with early feedback. Then the products go into the Release, which indicates that they are ready for production.

See [Semantic Versioning (SemVer)](https://semver.org/) in respect of the terminology used in this document, specifically "Pre-Release Version Suffix".

## Pre-Releases

The Pre-Release `<build>` component should always be a positive integer value.

### Labs

**Experimental features we do not support but may be evolved or removed depending on demand.**

### Alpha or Technical Preview

**Alpha products are for early testing and validation by a small and limited group of customers.**

These products will be Demo-able, work end-to-end but have limitations in functionality. Documentation may not be available for Alpha products. Not recommended for production environments. In case of encountering a serious issue we may not be able to fix it.

No SLAs apply to Alpha releases. We strongly recommend using Alpha software features in test environments only to avoid introducing risk to production deployments because we can’t guarantee that Alpha product works as specified and from build to build some breaking changes may be introduced.  

**Pre-Release Version Suffix:** `-alpha.<build>`

**GitHub Release Title format:** `<major>.<minor>.<patch>, Alpha <build>`

### Beta

**Beta products are made publicly available for testing piloting by a broader group of customers.**

Beta releases are _more_ feature complete and stable than Alpha releases, close to a release and will not change dramatically but bug fixes will be fixed and some additions and modifications can be introduced during this stage getting it close to the release. The use of Beta products in production environments may be appropriate, albeit with caution as issues may surface that need fixing and things could change in future versions.

Customers using the beta version should be aware that some outstanding issues may be present and consistency of interfaces are not guaranteed (i.e. behaviors and APIs may still change). Documentation will be present, but will evolve as the Engineering team addresses bugs and makes improvements in anticipation of Release.

**Pre-Release Version Suffix:** `-beta.<build>`

**GitHub Release Title format:** `<major>.<minor>.<patch>, Beta <build>`

### Release Candidate

**Release candidate product is supposed to be fully functional with a minimum number of  known issues and ready to be released after internal testing.**

This version is fully feature complete and stable, will not be changed in terms of API or its behavior, and may contain several known bugs. Documentation must be completed and may require verification. Technical support is ready to support this version, and soon the pricing policy will be fixed and announced (if applicable).

Release Candidate may be a subject to SLAs in some cases.

**Pre-Release Version Suffix:** `-rc.<build>`

**GitHub Release Title format:** `<major>.<minor>.<patch>, Release Candidate <build>`

## General Availability (Release)

**Generally Available products are considered to be fully supported and production ready.**

A product will become Generally Available (GA) when the Engineering team as well as designated Product manager has full confidence in its readiness for use in production contexts. While General Availability products can still be improved over time, Release products are considered feature complete and perform stably and reliably. Technical support engineers are fully trained and ready to support this version.

Release software products are subject to SLAs and are supported with publicly available pricing and complete documentation.

## Limited support

This version is coming to the end of its life. The engineering team does not develop this version, only critical issues are fixed, the version is supported by the technical support team, but all customers are strongly encouraged to upgrade to the new version. Limited support times vary by product.

## End of Life

This version is depreciated from sales, development or technical support.
