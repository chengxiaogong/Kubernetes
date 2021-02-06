# 生成k8s证书
cfssl gencert -initca ca-csr.json | cfssljson -bare ca -
cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=ca-config.json -profile=kubernetes server-csr.json | cfssljson -bare server
cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=ca-config.json -profile=kubernetes admin-csr.json | cfssljson -bare admin
cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=ca-config.json -profile=kubernetes kube-proxy-csr.json | cfssljson -bare kube-proxy

# ssl 证书根路径
root_dir=$(pwd | sed 's#/ssl/k8s-cert##g')

# k8s master playbook 角色, 证书路径
apiserver_cert_dir=${root_dir}/roles/master/files/k8s_cert

# k8s node playbook 角色, 证书路径
node_cert_dir=${root_dir}/roles/node/files/k8s_cert

# 创建证书目录
mkdir $apiserver_cert_dir $node_cert_dir

# 拷贝证书到 master roles 中去
cp -rf *.pem $apiserver_cert_dir
# 拷贝证书到 node roles 中去
cp -rf ca.pem kube-proxy-key.pem kube-proxy.pem $node_cert_dir

