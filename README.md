# Chef License Status
A simple tool for printing the current license status of your Chef server.

# Requirements
- Chef Server 12 or higher
- Console access to the Chef server
 
# Usage
Run this script on the console of the Chef Server. It will return a CSV with a timestamp, the hostname, and a count of the current number of nodes in use across the entire Chef Server. This can be piped to a file for consumption.

Example output:
```
Date,Hostname,Node Count
2015-03-03 02:42AM UTC,chef-demo-server.example.com,234
```

# Known issues
- Reports all nodes registered on the server at the time it is run, regardless of surge / burst usage.

# Author
Author:: Charles Johnson (charles@chef.io)

# License
Copyright 2015, Chef Software, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
