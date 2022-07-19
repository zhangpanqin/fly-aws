## 在 minikube 部署 istio
[Istio / Minikube](https://istio.io/latest/zh/docs/setup/platform-setup/minikube/)

[Istio / Bookinfo 应用](https://istio.io/latest/zh/docs/examples/bookinfo/)

```shell
colima stop
colima start --cpu 2 --memory 5 --disk 60
# 为了安装官方 demo 这里要有 4g 内存
minikube start --memory=4g --kubernetes-version=v1.23.0

./install.sh

# 一个是让 LoadBalancer 可以暴露 ip
minikube tunnel
# 一个是让 http://localhost/productpage 可以访问
minikube tunnel
```