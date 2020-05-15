# terragrunt-icon

Reference architecture for deploying various node configurations for the ICON Blockchain. 

> Supersedes [github.com/insight-icon/terragrunt-icon-monitor](https://github.com/insight-icon/terragrunt-icon-monitor)

**WIP - Too early to use unless you know what you are doing**

### Planned layout 

> Missing some providers / tests but this is roughly what it will look like. 

```bash
├── citizen
│   ├── aws
│   │   ├── network
│   │   ├── node
│   │   └── test
│   ├── azure
│   │   ├── network
│   │   ├── node
│   │   └── test
│   └── gcp
│       ├── network
│       ├── node
│       └── test
├── citizen-ha
│   ├── aws
│   │   ├── api-lb
│   │   ├── asg
│   │   ├── k8s-cluster
│   │   ├── k8s-config
│   │   ├── network
│   │   └── test
│   ├── azure
│   │   ├── api-lb
│   │   ├── asg
│   │   ├── k8s-cluster
│   │   ├── k8s-config
│   │   ├── network
│   │   └── test
│   └── gcp
│       ├── api-lb
│       ├── asg
│       ├── k8s-cluster
│       ├── k8s-config
│       ├── network
│       └── test
├── prep
│   ├── aws
│   │   ├── network
│   │   ├── node
│   │   ├── registration
│   │   └── test
│   ├── gcp
│   │   ├── network
│   │   ├── node
│   │   └── registration
│   └── packet
│       ├── node
│       └── registration
├── prep-ha
│   ├── aws
│   │   ├── network
│   │   ├── prep-ha
│   │   ├── registration
│   │   └── test
│   ├── gcp
│   │   ├── network
│   │   ├── node
│   │   └── registration
│   └── packet
│       ├── node
│       └── registration
├── sentry
│   ├── aws
│   │   ├── api-lb
│   │   ├── asg
│   │   ├── network
│   │   └── test
│   ├── azure
│   │   ├── api-lb
│   │   ├── asg
│   │   ├── network
│   │   └── test
│   └── gcp
│       ├── api-lb
│       ├── asg
│       ├── network
│       └── test
├── services-k8s
│   ├── aws
│   │   ├── k8s-cluster
│   │   ├── k8s-config
│   │   ├── network
│   │   └── test
│   ├── azure
│   │   ├── k8s-cluster
│   │   ├── k8s-config
│   │   ├── network
│   │   └── test
│   └── gcp
│       ├── k8s-cluster
│       ├── k8s-config
│       ├── network
│       └── test
└── services-node
    ├── aws
    │   ├── network
    │   ├── node
    │   └── test
    ├── azure
    │   ├── network
    │   ├── node
    │   └── test
    └── gcp
        ├── network
        ├── node
        └── test
```