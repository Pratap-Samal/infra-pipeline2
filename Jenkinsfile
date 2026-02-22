pipeline {
    agent any

    environment {
        AWS_DEFAULT_REGION = 'ap-south-1'
    }

    stages {

        stage('Terraform Init') {
            steps {
                dir('terraform') {
                    sh 'terraform init'
                }
            }
        }

        stage('Terraform Validate') {
            steps {
                dir('terraform') {
                    sh 'terraform validate'
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                dir('terraform') {
                    sh 'terraform plan -out=tfplan'
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                dir('terraform') {
                    sh 'terraform apply -auto-approve tfplan'
                }
            }
        }

        stage('Extract Public IP') {
            steps {
                dir('terraform') {
                    script {
                        env.PUBLIC_IP = sh(
                            script: "terraform output -raw public_ip",
                            returnStdout: true
                        ).trim()
                    }
                }
            }
        }

        stage('Generate Inventory') {
            steps {
                dir('ansible') {
                    writeFile file: 'inventory.ini', text: """
[web]
${env.PUBLIC_IP} ansible_user=ec2-user
"""
                }
            }
        }



        stage('Ansible Deploy') {
            steps {
                dir('ansible') {
                    withCredentials([
                        sshUserPrivateKey(
                            credentialsId: 'ec2-ssh-key',
                            keyFileVariable: 'SSH_KEY'
                        )
                    ]) {
                        sh """
                        ansible-playbook -i inventory.ini playbook.yml \
                        --private-key $SSH_KEY
                        """
                    }
                }
            }
        }
    }

    post {
        always {
            echo "EC2 Public IP: ${env.PUBLIC_IP}"
        }
    }
}