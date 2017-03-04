Vagrant.configure("2") do |config|
    config.vm.box = "bento/centos-7.3"
    config.vm.provision "shell", path: "scripts/setup.sh"
    config.vm.network :forwarded_port, host: 8080, guest: 8080
    config.vm.network :forwarded_port, host: 9000, guest: 9000
    config.ssh.insert_key = true
    config.vm.synced_folder '.', '/vagrant', disabled: true

    config.vm.provider :virtualbox do |vb|
        vb.gui = true
        vb.customize "pre-boot", [
            "storageattach", :id,
            "--storagectl", "IDE Controller",
            "--port", "1",
            "--device", "0",
            "--type", "dvddrive",
            "--medium", "emptydrive",
            ]
        # Use VBoxManage to customize the VM. For example to change memory:
        vb.customize ["modifyvm", :id, "--name", "jhipster-devbox-centos"]
        vb.customize ["modifyvm", :id, "--memory", "4096"]
        vb.customize ["modifyvm", :id, "--vram", 64]
        vb.customize ["modifyvm", :id, "--accelerate3d", "on"]
        vb.customize ['modifyvm', :id, '--clipboard', 'bidirectional']
        vb.customize ['modifyvm', :id, '--draganddrop', 'bidirectional']
    end
end
