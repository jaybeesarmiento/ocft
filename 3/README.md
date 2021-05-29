# Write a Kubernetes pod manifest that uses 2 images for which the container of the first image will copy file.txt to a shared path followed by starting the container of the second image with the shared path mounted


```
kubectl apply -f manifest.yml
```

## To check pods
```
kubectl get pods
kubectl exec --stdin --tty copy-file -- /bin/bash
```