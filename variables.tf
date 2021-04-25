variable "region" {
  description = "Define Region"
  type        = string
  default = "eu-west-1"
}
variable "grafana_subnet_id" {
  description = "Define Subnet for Grafana Instance"
  type        = string
  default = "subnet-d32f339b"
}

variable "grafana_instance_SG" {
  description = "Define Security Groups for Grafana Instance"
  type        = list(string)
  default = ["sg-b233b7e9"]
}

#variable "grafana_db_subnet" {
#  description = "Define Grafana Database Subnet"
#  type        = string
#  default = "subnet-d32f339b"
#}

variable "grafana_db_SG" {
  description = "Define Security Groups for Grafana Database"
  type        = list(string)
  default = ["sg-b233b7e9"]
}

variable "DB_TEMPLATE" {
  description = "Define Structure for Grafana Database"
  type        = string
  default = <<EOF
CREATE TABLE \`envreport\` (
  \`id\` int(11) NOT NULL AUTO_INCREMENT,
  \`environment\` varchar(45) NOT NULL,
  \`packages\` text,
  \`author\` text,
  \`publish\` text,
  \`publish00\` text,
  \`publish01\` text,
  \`publish02\` text,
  \`publish03\` text,
  \`publish04\` text,
  \`hybris\` text,
  \`hybrishmc\` varchar(45) DEFAULT NULL,
  \`hybrisapi01\` varchar(45) DEFAULT NULL,
  \`hybrisapi02\` varchar(45) DEFAULT NULL,
  \`hybrisapi03\` varchar(45) DEFAULT NULL,
  \`hybrisapi04\` varchar(45) DEFAULT NULL,
  \`cookbook\` text,
  \`cookbook_version\` text,
  \`cookbook_status\` text,
  \`author0\` text,
  \`publishjobrunner0\` text,
  \`publish0\` text,
  \`publish1\` text,
  \`publish2\` text,
  \`publish3\` text,
  \`hybrisbackoffice0\` text,
  \`hybris0\` text,
  \`hybris1\` text,
  \`hybris2\` text,
  \`hybris3\` text,
  PRIMARY KEY (\`id\`),
  UNIQUE KEY \`id_UNIQUE\` (\`id\`),
  KEY \`idx_new_table_id\` (\`id\`)
) ENGINE=InnoDB AUTO_INCREMENT=73 DEFAULT CHARSET=latin1;

CREATE TABLE \`envreportblue\` (
  \`id\` int(11) NOT NULL AUTO_INCREMENT,
  \`environment\` varchar(45) NOT NULL,
  \`cookbook\` text,
  \`cookbook_version\` text,
  \`cookbook_status\` text,
  \`packages\` text,
  \`author0\` text,
  \`publishjobrunner0\` text,
  \`publish0\` text,
  \`publish1\` text,
  \`publish2\` text,
  \`publish3\` text,
  \`hybrisbackoffice0\` text,
  \`hybris0\` text,
  \`hybris1\` text,
  \`hybris2\` text,
  \`hybris3\` text,
  PRIMARY KEY (\`id\`),
  UNIQUE KEY \`id_UNIQUE\` (\`id\`),
  KEY \`idx_new_table_id\` (\`id\`)
) ENGINE=InnoDB AUTO_INCREMENT=83 DEFAULT CHARSET=latin1;
 CREATE USER \'grafanaReader\' IDENTIFIED BY \'password\';
 GRANT SELECT ON grafana.envreport TO \'grafanaReader\';
 GRANT SELECT ON grafana.envreportblue TO \'grafanaReader\';
EOF
}
