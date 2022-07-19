import json
import boto3

ec2 = boto3.client('ec2')

def get_instance(c_state):
    response_ec2=ec2.describe_instances(
        Filters = [
            {
                'Name': 'instance-state-name',
                'Values': [c_state]
            }
        ]
    )['Reservations']

    return response_ec2

def stop_instances(c_ins_id):
    ec2.stop_instances(
        InstanceIds=[c_ins_id]
    )


def lambda_handler(event, context):
    get_ec2_instances = get_instance('running')

    if not get_ec2_instances:
        return {
            "message : ": "No instances running"
        }
    else:
        for ins in range(0,len(get_ec2_instances)):
            instanceId = get_ec2_instances[ins]['Instances'][0]['InstanceId']
            tags = get_ec2_instances[ins]['Instances'][0]['Tags']
            tags_dict = {}

            stop_instances(instanceId)
            
            return {
                
                "Stopping Instance ID : ": instanceId
            }
