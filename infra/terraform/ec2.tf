resource "aws_instance" "rails_seed" {
    ami                         = "ami-06cd52961ce9f0d85"
    availability_zone           = "ap-northeast-1c"
    ebs_optimized               = false
    instance_type               = "t2.small"
    monitoring                  = false
    key_name                    = "rails_seed"
    associate_public_ip_address = false

    root_block_device {
        volume_type           = "gp2"
        volume_size           = 8
        delete_on_termination = true
    }

    tags {
        "Group" = "rails_seed"
        "Name" = "rails_seed"
    }
}
