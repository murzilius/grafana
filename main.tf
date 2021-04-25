provider "aws" {
  region = var.region
}
# Getting Latest Amazon Linux 2 AMI
data "aws_ami" "AL2" {
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
  owners = ["137112412989"] # Amazon
}
# Retrive Secret
data "aws_secretsmanager_secret" "secrets" {
  name = "cicd/grafana"
}

data "aws_secretsmanager_secret_version" "current" {
  secret_id = data.aws_secretsmanager_secret.secrets.id
}
locals {
  dbpw = data.aws_secretsmanager_secret_version.current.secret_string
}
# Create RDS Instance (MySQL)
resource "aws_db_instance" "GrafanaDB" {
  #db_subnet_group_name = var.grafana_db_subnet
  vpc_security_group_ids = var.grafana_db_SG
  identifier = "grafanadb"
  allocated_storage    = 20
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  name                 = "grafana"
  username             = "root"
  password             = local.dbpw
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
}
#Create Grafana Instance
resource "aws_instance" "Grafana_instance" {
  ami           = data.aws_ami.AL2.id
  instance_type = "t2.micro" //Is A Free instance
  tags = {
    Name = "Grafana for CICD"
  }
  key_name="Grafana_key"
  subnet_id = var.grafana_subnet_id
  vpc_security_group_ids = var.grafana_instance_SG
  user_data = templatefile("./Templates/grafana.sh.tmpl", {
                      DB_PW = local.dbpw, 
                      DB_ENDPOINT = aws_db_instance.GrafanaDB.endpoint, 
                      DB_TEMPLATE = var.DB_TEMPLATE
#                      chef_env_validation_pem_key = data.aws_ssm_parameter.validation_pem.value
#                      chef_run_list = "test"
                      })
}
//Are we need it?  Lets Fetch string from manager!
resource "aws_key_pair" "AWS" {
  key_name   = "Grafana_key"
  public_key = file("./Files/Key.pub")                  //give servers Public Key
}
# Get ALB target group
data "aws_lb_target_group" "grafana" {
  name = "grafana"
}
# Attach Instance to ALB Target Group
resource "aws_lb_target_group_attachment" "grafana" {
  target_group_arn = data.aws_lb_target_group.grafana.arn
  target_id        = aws_instance.Grafana_instance.id
  port             = 80
}
# Get Chef validation key
#data "aws_ssm_parameter" "validation_pem" {
#  name = "/chef/gdp/org_validation_pem"
#  with_decryption = true
#}


