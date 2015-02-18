# Chef License Status
A simple tool for printing the current license status of your Chef server.

# Requirements
- Chef Server 12 or higher
- Console access to the Chef server
 
# Usage
Run this script on the console of the Chef Server. It will return a 30-day table of the Chef server usage in CSV format.

Example output:
```
as_of_date,node_count,node_count_since_yesterday,node_count_past_7days
2015-02-18,2,2,2
2015-02-17,2,2,2
2015-02-16,2,2,2
...
2015-01-19,2,2,2
```

# Known issues
- Will return 30 days of output even if the server has not been in use for 30 days. Disregard any output recorded for extra history.

# Author
Author:: Chris Doherty   (cdoherty@chef.io)
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
