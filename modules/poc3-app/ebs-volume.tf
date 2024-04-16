# Create EBS Volumes and attach them to Windows EC2 instances
resource "aws_ebs_volume" "ebs_volume_for_windows_ec2" {
  availability_zone = data.aws_subnet.private_vpc_private_subnet.availability_zone
  size              = var.ebs_size

  tags = {
    Name = "ebs-${var.instance_name_prefix}"
  }
}

resource "aws_volume_attachment" "ebs_att" {
  device_name = var.ebs_device_name
  volume_id   = aws_ebs_volume.ebs_volume_for_windows_ec2.id
  instance_id = aws_instance.ec2_instance.id
}
