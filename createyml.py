import ConfigParser
import yaml
import io

data = {}

with open('docker-compose.yml', 'rw') as f:
  containeryml = yaml.load(f)

# Load the configuration file
with open("config.ini") as f:
    sample_config = f.read()

config = ConfigParser.RawConfigParser(allow_no_value=True)
config.readfp(io.BytesIO(sample_config))

node_count = config.get('storage', 'node')
data_type = config.get('storage', 'data')



for i in range(1, int(node_count)+1):
  servicename = "glusternode" + str(i)
  ip = "10.5.0." + str(i + 2);
  hostname = "gluster" + str(i)
  data[servicename]= {}
  data[servicename]["privileged"] = True
  data[servicename]["image"] = "ankushbehl/gluster-centos"
  data[servicename]["hostname"] = hostname
  data[servicename]["networks"] = {}
  data[servicename]["networks"]["vpcbr"] = {"ipv4_address": ip}
  
  if(data_type == "persistent"):
    data[servicename]["volumes"] = [
     "/var/log/glusterfs" + str(i) +":/var/log/glusterfs:z",
     "/var/lib/glusterd" + str(i) + ":/var/lib/glusterd:z",
     "/etc/glusterfs" + str(i) +":/etc/glusterfs:z",
     "/dev/:/dev",
     "/sys/fs/cgroup:/sys/fs/cgroup:ro"
    ]
  else:
    data[servicename]["volumes"] = [
     "/sys/fs/cgroup:/sys/fs/cgroup:ro"
    ]

  data[servicename]["container_name"] = hostname


tendrldata = {
    "privileged": True,
    "image": "ankushbehl/tendrl-centos",
    "hostname": "tendrlserver",
    "ports":["2379:2379", "80:80", "3000:3000", "10080:10080"],
    "networks": {
      "vpcbr": {
        "ipv4_address": "10.5.0.2"
      }
    },     
    "volumes": [
       "/sys/fs/cgroup:/sys/fs/cgroup:ro"
    ],
    "container_name": "tendrl_server",
    "restart": "always"
}

data["tendrlnode"] = tendrldata;
containeryml["services"] = data

with open('docker-compose.yml', 'w') as outfile:
    yaml.dump(containeryml, outfile, default_flow_style=False)

