kubectl apply -f k8s/clusterrolebinding-*.yaml

export TILLER_NAMESPACE=default
helm init --tiller-namespace default --service-account default

sleep 120

helm upgrade --install kube2iam -f helm/kube2iam-values.yaml stable/kube2iam

sleep 120

kubectl create ns aws-service-operator
helm upgrade --install aws-service-operator --namespace aws-service-operator -f helm/aws-service-operator-values.yaml ../../awslabs/aws-service-operator/charts/aws-service-operator

sleep 30
kubectl apply -f ../../awslabs/aws-service-operator/examples/cloudformationtemplates
