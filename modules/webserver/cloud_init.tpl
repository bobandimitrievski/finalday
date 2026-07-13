#cloud-config
hostname: $(hostname)
package_upgrade: true
packages:
    - nginx
runcmd:
    - systemctl enable nginx
    - systemctl start nginx