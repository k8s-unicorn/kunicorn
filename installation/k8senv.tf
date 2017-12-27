resource "qingcloud_eip" "k8seip"{
  name = "k8sDeveip"
  description = "k8s dev eip"
  billing_mode = "traffic"
  bandwidth = 20
  need_icp = 0
}

resource "qingcloud_security_group" "k8sfirewall"{
  name = "k8s防火墙"
  description = "k8s防火墙"
}

resource "qingcloud_security_group_rule" "allow-in-19999"{
  name = "允许使用80"
  security_group_id  = "${qingcloud_security_group.k8sfirewall.id}"
  protocol = "tcp"
  priority = 1
  action = "accept"
  direction = 0
  from_port = "1190"
  to_port = "19999"
}

resource "qingcloud_keypair" "arthur"{
  name = "martinmac"
  description = "martin mac ssl key"
  public_key = "${file("~/.ssh/id_rsa.pub")}"
}

resource "qingcloud_vpc" "k8svpc"{
  name = "k8svpc"
  type = 1
  vpc_network = "172.16.0.0/16"
  security_group_id = "${qingcloud_security_group.k8sfirewall.id}"
  description = "测试的网络"
  eip_id = "${qingcloud_eip.k8seip.id}"
}

resource "qingcloud_vpc_static" "k8svpcconf"{
  vpc_id = "${qingcloud_vpc.k8svpc.id}"
  static_type = 2
  val1 = "openvpn"
  val2 = "1194"
  val3 = "tcp"
}

resource "qingcloud_vxnet" "k8snodevxnet"{
  name = "k8s node vxnet"
  type = 1
  description = "应用的网络"
  vpc_id = "${qingcloud_vpc.k8svpc.id}"
  ip_network = "172.16.1.0/24"
}

resource "qingcloud_vxnet" "k8spodvxnet1"{
  name = "k8s pod vxnet"
  type = 1
  description = "应用的网络"
  vpc_id = "${qingcloud_vpc.k8svpc.id}"
  ip_network = "172.16.2.0/24"
}

resource "qingcloud_vxnet" "k8spodvxnet2"{
  name = "k8s pod vxnet"
  type = 1
  description = "应用的网络"
  vpc_id = "${qingcloud_vpc.k8svpc.id}"
  ip_network = "172.16.3.0/24"
}

resource "qingcloud_instance" "master"{
  image_id = "xenial3x64"
  instance_class = "1"
  cpu = 4
  memory = 8192
  managed_vxnet_id = "${qingcloud_vxnet.k8snodevxnet.id}"
  keypair_ids = ["${qingcloud_keypair.arthur.id}"]
  connection {
      type     = "ssh"
      user     = "root"
      private_key = "${file("~/.ssh/id_rsa")}"
      host = "${self.private_ip}"
  }
  provisioner "remote-exec" {
    inline = [
      "curl -L https://bootstrap.saltstack.com -o install_salt.sh",
      "sudo sh install_salt.sh -P -M"
    ]
  }

  provisioner "salt-masterless" {
    "local_state_tree" = "saltbase/salt"
    "local_pillar_roots" = "saltbase/pillar"
    "remote_pillar_roots"= "/srv/pillar"
    "remote_state_tree" = "/srv/salt"
    "skip_bootstrap"= true
    "log_level" = "debug"
  }
}

resource "qingcloud_instance" "slave"{
  image_id = "centos74x64"
  cpu = 4
  memory = 8192
  instance_class = "1"
  managed_vxnet_id = "${qingcloud_vxnet.k8snodevxnet.id}"
  keypair_ids = ["${qingcloud_keypair.arthur.id}"]
  connection {
      type     = "ssh"
      user     = "root"
      private_key = "${file("~/.ssh/id_rsa")}"
      host = "${self.private_ip}"
  }
  provisioner "remote-exec" {
    inline = [
      "curl -L https://bootstrap.saltstack.com -o install_salt.sh",
      "sudo sh install_salt.sh -P"
    ]
  }
  provisioner "salt-masterless" {
    "local_state_tree" = "saltbase/salt"
    "local_pillar_roots" = "saltbase/pillar"
    "remote_pillar_roots"= "/srv/pillar"
    "remote_state_tree" = "/srv/salt"
    "skip_bootstrap"= true
    "log_level" = "debug"
  }
}
