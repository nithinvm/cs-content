#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Executes a no-op SSH command.
#
# Inputs:
#   - host - Docker machine host
#   - port - optional - SSH port - Default: 22
#   - username - Docker machine username
#   - password - optional - Docker machine password
#   - privateKeyFile - optional - absolute path to private key file
#   - arguments - optional - arguments to pass to the command
#   - characterSet - optional - character encoding used for input stream encoding from target machine - Valid: SJIS, EUC-JP, UTF-8 - Default: UTF-8
#   - pty - optional - whether to use PTY - Valid: true, false - Default: false
#   - timeout - time in milliseconds to wait for command to complete - Default: 30000000
#   - closeSession - optional - if false SSH session will be cached for future calls during the life of the flow, if true the SSH session used will be closed; Valid: true, false - Default: false
#   - agentForwarding - optional  - the sessionObject that holds the connection if the close session is false
# Outputs:
#   - response - Linux welcome message
#   - error_message

#   - return_result - contains the exception in case of failure, success message otherwise
#   - return_code - "0" if successful, "-1" otherwise
#   - standard_out - STDOUT of the machine in case of successful request, null otherwise
#   - exception - exception in case of failure
#   - exit_status - return code of the remote command
# Results:
#   - SUCCESS
#   - FAILURE
####################################################

namespace: io.cloudslang.base.os.linux

operation:
  name: validate_linux_machine_ssh_access
  inputs:
    - host
    - port: '22'
    - username
    - password:
        required: false
    - privateKeyFile:
        required: false
    - command:
        default: ':'
        overridable: false
    - arguments:
        required: false
    - characterSet: 'UTF-8'
    - pty: 'false'
    - timeout: '30000000'
    - closeSession: 'false'
    - agentForwarding:
        required: false
  action:
    java_action:
      className: io.cloudslang.content.ssh.actions.SSHShellCommandAction
      methodName: runSshShellCommand
  outputs:
    - return_result: ${ get('returnResult', '') }
    - return_code: ${ returnCode }
    - standard_out: ${ get('STDOUT', '') }
    - standard_err: ${ get('STDERR', '') }
    - exception: ${ get('exception', '') }
    - exit_status: ${ get('exitStatus', '') }
  results:
    - SUCCESS : ${ returnCode == '0' and (not 'Error' in STDERR) }
    - FAILURE
