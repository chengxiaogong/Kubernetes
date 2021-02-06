# 生成etcd 证书
cfssl gencert -initca ca-csr.json | cfssljson -bare ca -
cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=ca-config.json -profile=www server-csr.json | cfssljson -bare server

# ssl 证书根路径
root_dir=$(pwd | sed 's#/ssl/etcd-cert##g')

# etcd playbook 角色, 证书路径
etcd_cert=${root_dir}/roles/etcd/files/etcd_cert

# master playbook 角色, 证书路径
master_cert=${root_dir}/roles/master/files/etcd_cert

# 创建证书目录
mkdir $etcd_cert $master_cert
for dir in $etcd_cert $master_cert
do
  # 拷贝etcd证书到etcd 和 master roles 中去
  cp ca.pem server.pem server-key.pem $dir
done



