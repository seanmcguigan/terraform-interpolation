provider "aws" {
  region     = "eu-west-1"
}

# List Interpolation
data "aws_availability_zones" "available" {}

data "aws_subnet_ids" "private" {
  vpc_id = "vpc-31aa8b56"
  tags {
    environment = "nonprod"
  }
}

output "subnets" {
	value = "${data.aws_subnet_ids.private.ids}"
}
/*
RESULT
subnets = [
    subnet-33bce67a,
    subnet-91d04cca,
    subnet-ffb0eab6,
    subnet-72d14d29,
    subnet-c3b1eb8a,
    subnet-e9d24eb2
]
*/

output "az" {
  value = "${data.aws_availability_zones.available.names}"
}
/*
 RESULT
 az = [
    eu-west-1a,
    eu-west-1b,
    eu-west-1c
]
*/

/*
contains(list, element) - Returns true if a list contains the given element and returns false otherwise. 
Examples: contains(var.list_of_strings, "an_element")
*/
output "az_contains" {
  value = "${contains(data.aws_availability_zones.available.names, "eu-west-1a")}"
}
# RESULT
# az_contains = true

/*
element(list, index) - Returns a single element from a list at the given index. 
If the index is greater than the number of elements, this function will wrap using a standard mod algorithm. 
This function only works on flat lists
*/
output "az_element" {
  value = "${element(data.aws_availability_zones.available.names, 0)}"
}
# RESULT
# az_element = eu-west-1a

/*
join(delim, list) - Joins the list with the delimiter for a resultant string. 
This function works only on flat lists. 
*/
output "az_join" {
  value = "${join(",", data.aws_availability_zones.available.names)}"
}
# RESULT
# az_join = eu-west-1a,eu-west-1b,eu-west-1c

/*
concat(list1, list2, ...) - Combines two or more lists into a single list. 
Example: concat(aws_instance.db.*.tags.Name, aws_instance.web.*.tags.Name)
*/
output "az_subnets_concat" {
	value = "${concat(data.aws_availability_zones.available.names, data.aws_subnet_ids.private.ids)}"
}
/* RESULT
az_subnets_concat = [
    eu-west-1a,
    eu-west-1b,
    eu-west-1c,
    subnet-33bce67a,
    subnet-91d04cca,
    subnet-ffb0eab6,
    subnet-72d14d29,
    subnet-c3b1eb8a,
    subnet-e9d24eb2
]
*/

/*
length(list) - Returns the number of members in a given list or map, 
or the number of characters in a given string.
*/
output "subnets_length" {
    value = "${length(data.aws_subnet_ids.private.ids)}"
}
# RESULT
# subnets_length = 6

/*
list(items, ...) - Returns a list consisting of the arguments to the function. 
This function provides a way of representing list literals in interpolation.
*/
output "az_subnets_list" {
	value = "${list(data.aws_availability_zones.available.names, data.aws_subnet_ids.private.ids)}"
}
/* RESULTS
az_subnets_list = [
    [
        eu-west-1a,
        eu-west-1b,
        eu-west-1c
    ],
    [
        subnet-33bce67a,
        subnet-91d04cca,
        subnet-ffb0eab6,
        subnet-72d14d29,
        subnet-c3b1eb8a,
        subnet-e9d24eb2
    ]
]
*/

/*
slice(list, from, to) - Returns the portion of list between from (inclusive) and to (exclusive). 
Example: slice(var.list_of_strings, 0, length(var.list_of_strings) - 1)
*/
output "subnets_slice" {
    value = "${slice(data.aws_subnet_ids.private.ids, 1, 3)}"
}
 /* RESULT
  subnets_slice = [
    subnet-91d04cca,
    subnet-ffb0eab6
    ]
]*/

  # String Interpolation
variable "az" { default = "eu-west-1a,eu-west-1b,eu-west-1c" }
variable "subnets" { default = "subnet-33bce67a,subnet-91d04cca,subnet-ffb0eab6" }

output "az_string" {
	value = "${var.az}"
}
# az_string = eu-west-1a,eu-west-1b,eu-west-1c

output "subnets_string" {
	value = "${var.subnets}"
}
# subnets_string = subnet-33bce67a,subnet-91d04cca,subnet-ffb0eab6

/*
coalesce(string1, string2, ...) - Returns the first non-empty 
value from the given arguments. At least two arguments must be provided.
*/
output "coalesce_az_string_subnet_string" {
	value = "${coalesce(var.az, var.subnets)}"
}
/* RESULT
coalesce_az_string_subnet_string = eu-west-1a,eu-west-1b,eu-west-1c
*/

/*
split(delim, string) - Splits the string previously created by join back into a list. 
This is useful for pushing lists through module outputs since they currently only support string values. 
Depending on the use, the string this is being performed within may need to be wrapped 
in brackets to indicate that the output is actually a list, 
e.g. a_resource_param = ["${split(",", var.CSV_STRING)}"]. Example: split(",", module.amod.server_ids)
*/
output "split_subnets" {
	value = "${split(",", var.subnets)}"
}
/* RESULT
split_subnets = [
    subnet-33bce67a,
    subnet-91d04cca,
    subnet-ffb0eab6
]
*/

/*
substr(string, offset, length) - Extracts a substring from the input string. 
A negative offset is interpreted as being equivalent to a positive offset measured backwards 
from the end of the string. A length of -1 is interpreted as meaning "until the end of the string".
*/
output "substr_string_subnets" {
	value = "${substr(var.subnets, 16, 15)}"
}
/* RESULT
substr_string_subnets = subnet-91d04cca
*/

output "length_subnet_string" {
	value = "${length(var.subnets)}"
}
# RESULT
# length_subnet_string = 47
	
locals {
  map = {
    map_key1 = "map_value1",
    map_key2 = "map_value2"
  }
  list = [
    "list_item1",
    "list_item2"
  ]
  string1 = "foo"
  string2 = "bar"
}

# [] result in a tuple
output "upper_list_item" {
  value = [for s in local.list : upper(s)]
}

# count and add lenths of strings
output "length_map_item" {
  value = [for k, v in local.map : length(k) + length(v)]
}

# show index and value
output "index" {
  value = [for i, v in local.list : "${i} is ${v}"]
}

# If you use { and } instead, the result is an object 
# and you must provide two result expressions that are separated by the => symbol:
# map output.
output "map" {
  value = {for k, v in local.map : k => upper(v)}
}

# filtering with if
output "filtering" {
  value = {for k, v in local.map : k => upper(v) if v ! = "map_value1"}
}

filtering = {
  "map_key2" = "MAP_VALUE2"
}
index = [
  "0 is list_item1",
  "1 is list_item2",
]
length_map_item = [
  18,
  18,
]
map = {
  "map_key1" = "MAP_VALUE1"
  "map_key2" = "MAP_VALUE2"
}
upper_list_item = [
  "LIST_ITEM1",
  "LIST_ITEM2",
]

# locals {
#   map = {
#     map_key1 = "map_value1",
#     map_key2 = "map_value2"
#   }
#   list = [
#     "One",
#     "Two",
#     "Three",
#     "Four"
#   ]
#   list2 = [
#     "s",
#     "k",
#     "a",
#     "y"
#   ]
#   string1 = "foo"
#   string2 = "bar"
# }

# output "nested" {
#   value = [for i in local.list : i]
# }

# output "keys" {
#   value = keys(local.map)
# }

# output "values" {
#   value = values(local.map)
# }

# # [] result in a tuple
# output "upper_list_item" {
#   value = toset([for s in local.list2 : upper(s)]) #toset = ordered list
# }

# # count and add lenths of strings
# output "length_map_item" {
#   value = [for k, v in local.map : length(k) + length(v)]
# }

# # show index and value
# output "index" {
#   value = [for i, v in local.list : "${i} is ${v}"]
# }

# # If you use { and } instead, the result is an object 
# # and you must provide two result expressions that are separated by the => symbol:
# # map output.
# output "map" {
#   value = { for k, v in local.map : k => upper(v) }
# }

# # filtering with if
# output "filtering" {
#   value = { for k, v in local.map : k => upper(v) if v != "map_value1" }
# }

# # lookup, lookup retrieves the value of a single element from a map, given its key. 
# # If the given key does not exist, the given default value is returned instead.
# output "lookup" {
#   value = lookup(local.map, "map_key3", "default value when key is missing")
# }

# conditional logic
# output "b2" {
#   value = keys({a = 1, b = 2, c = 3}) == ["a","b","c"] ? "is true" : "is false"
# }
# # Wrapping the multi-line ternary expressions with (...). Example:
# output "c3" {
#   value = (
#             contains(["a","b","c"], "d")
#               ? "is true"
#               : "is false"
#           )
# }
# # to create resource or not to create resource
# variable "create1" {
#   default = true
# }
# resource "random_pet" "pet1" {
#   count = var.create1 ? 3 : 0
#   length = 2
# }
# output "pet1" {
#   value = toset(random_pet.pet1[*].id)
# }

# for_each - The recommended way to use a for_each loop is with a Map value. 
# It’s a natural fit since we don’t have to do any toset conversion. 
# It also nicely reduces mental overhead.

# resource "null_resource" "simple" {
#   count = 2
# }
# output "simple" {
#   value = null_resource.simple[*].id
# }

# locals {
#   names = ["bob", "kevin", "stewart", "andy"]
# }
# resource "null_resource" "names" {
#   count = length(local.names)
#   triggers = {
#     name = local.names[count.index]
#   }
# }
# output "names" {
#   value = toset(null_resource.names[*].triggers.name) # toset function order list
# }

# locals {
#   minions = ["bob", "kevin", "stewart"]
# }
# resource "null_resource" "minions" {
#   for_each = toset(local.minions)
#   triggers = {
#     name = each.value
#   }
# }
# output "minions" {
#   value = [ for k, v in null_resource.minions: k ]
# }

# for_each acts on the resource level or the attribute level.
# Again - The recommended way to use a for_each loop is with a Map value.
# locals {
#   heights = {
#     bob     = "short"
#     kevin   = "TALL"
#     stewart = "medium"
#   }
# }
# resource "null_resource" "heights" {
#   for_each = local.heights
#   triggers = {
#     name   = each.key
#     height = each.value
#   }
# }
# output "heights" {                                                    # conditional
#   value = { for k,v in null_resource.heights : k => v.triggers.height if v.triggers.height != upper("tall") } 
# }

# dynamic loops
# locals {
#   map = {
#     "description 0" = {
#       port = 80,
#       cidr_blocks = ["0.0.0.0/0"],
#     }
#     "description 1" = {
#       port = 81,
#       cidr_blocks = ["10.0.0.0/16"],
#     }
#   }
# }
# resource "aws_security_group" "map" {
#   name        = "demo-map"
#   description = "demo-map"

#   dynamic "ingress" {
#     for_each = local.map
#     # normally would be "ingress" here, but we're overriding the name
#     iterator = each
#     content {
#       # now we use each. instead of ingress.
#       description = each.key # IE: "description 0"
#       from_port   = each.value.port
#       to_port     = each.value.port
#       protocol    = "tcp"
#       cidr_blocks = each.value.cidr_blocks
#     }
#   }
# }

# nested loops
# locals {
#   names = ["demo-example-1", "demo-example-2"]
# }
# locals {
#   ports = [80, 81]
# }
# resource "aws_security_group" "names" {
#   for_each    = toset(local.names)

#   name        = each.value # key and value is the same for sets
#   description = each.value

#   dynamic "ingress" {
#     for_each = local.ports
#     content {
#       description = "description ${ingress.key}"
#       from_port   = ingress.value
#       to_port     = ingress.value
#       protocol    = "tcp"
#       cidr_blocks = ["0.0.0.0/0"]
#     }
#   }
# }
# output "security_groups" {
#   value = aws_security_group.names
# }

# We did is “naive” because currently, the dynamic nested block 
# has the same ingress security rules for every security group. 
# IE: cidr_blocks = ["0.0.0.0/0"]. That’s not very useful.

# locals {
#   groups = {
#     example0 = {
#       description = "sg description 0"
#       rules = [{
#         description = "rule description 0",
#         port = 80,
#         cidr_blocks = ["10.0.0.0/16"],
#       },{
#         description = "rule description 1",
#         port = 81,
#         cidr_blocks = ["10.1.0.0/16"],
#       }]
#     },
#     example1 = {
#       description = "sg description 1"
#       rules = [{
#         description = "rule description 0",
#         port = 80,
#         cidr_blocks = ["10.2.0.0/16"],
#       },{
#         description = "rule description 1",
#         port = 81,
#         cidr_blocks = ["10.3.0.0/16"],
#       }]
#     }
#   }
# }
# resource "aws_security_group" "that" {
#   for_each    = local.groups

#   name        = each.key # top-level key is security group name - example0
#   description = each.value.description

#   dynamic "ingress" {
#     for_each = each.value.rules # List of Maps with rule attributes [ { = ,  = , = []}, { = ,  = , = []} ]
#     content {
#       description = ingress.value.description
#       from_port   = ingress.value.port
#       to_port     = ingress.value.port
#       protocol    = "tcp"
#       cidr_blocks = ingress.value.cidr_blocks
#     }
#   }
# }
# output "security_groups" {
#   value = aws_security_group.this
# }

# resource "random_string" "resource_code" {
#   length  = 5
#   special = false
#   upper   = false
# }

# output "resource_code" {
#   value = random_string.resource_code.result
# }

# resource "random_id" "my_id" {
#   byte_length = 8
# }

# # full object
# output "my_id" {  
#     value = random_id.my_id
# }

# resource "random_password" "my_password" {
#   length  = 12
#   special = true
# }

# output "my_password" {
#   value = random_password.my_password.result
#   sensitive = true
# }
# locals {
#   groups = {
#     example0 = {
#       description = "sg description 0"
#     },
#     example1 = {
#       description = "sg description 1"
#     }
#   }

#   rules = {
#     example0 = [{
#       description      = "rule description 0"
#       to_port          = 80
#       from_port        = 80
#       protocol         = "tcp"
#       cidr_blocks      = ["10.0.0.0/16"]
#       ipv6_cidr_blocks = null
#       prefix_list_ids  = null
#       security_groups  = null
#       self             = null
#     },{
#       description      = "rule description 1"
#       to_port          = 80
#       from_port        = 80
#       protocol         = "tcp"
#       cidr_blocks      = ["10.1.0.0/16"]
#       ipv6_cidr_blocks = null
#       prefix_list_ids  = null
#       security_groups  = null
#       self             = null
#     }]
#     example1 = [] # empty List removes previous rules
#   }
# }
# resource "aws_security_group" "this" {
#   for_each    = local.groups

#   name        = each.key # top-level key is security group name
#   description = each.value.description

#   # direct assignment of List of Maps
#   # lookup, lookup retrieves the value of a single element from a map, given its key. 
#   # If the given key does not exist, the given default value is returned instead.
#   ingress = lookup(local.rules, each.key, null) == null ? [] : local.rules[each.key]# each key value
# }

# locals {
#   list = {a = 1, b = 2, c = 3}
# }
# output "result1" {
#   value = {for k,v in local.list : k => v}
# }
# output "result2" {
#   value = [for k in local.list : k ] # always returns the value
# }


# locals {
#   list2 = ["a","b","c"]
# }
# output "result" {
#   value = {for i in local.list2 : i => upper(i) }
# }

# locals {
#   list = [
#     {a = 1, b = 5},
#     {a = 2, b = 6},
#     {a = 3, b = 7},
#     {a = 4, b = 8},
#   ]
# }
# output "list" {
#   value = [for m in local.list : values(m) if m.b > 6 ]
# }

# locals {
#   list = [
#     {a = 1, b = 5},
#     {a = 2},
#     {a = 3},
#     {a = 4, b = 8},
#   ]
# }
# # contains determines whether a given list or set contains a given single value as one of its elements.
# # contains(list, value)
# output "list" {
#   value = [for m in local.list : m if contains(keys(m), "b") ]
# }

#substr extracts a substring from a given string by offset and length.
# substr(string, offset, length)
# locals {
#   list = [
#     "mr bob",
#     "mr kevin",
#     "mr stuart",
#     "ms anna",
#     "ms april",
#     "ms mia",
#   ]
# }
# output "list" {
#   value = {for s in local.list : s => s...}#substr(s, 0, 2) => s...}
# }

locals {
  endpoints = {
    one = {
      name = "/database/one/endpoint"
      description = "Endpoint to connect to the one database"
      type        = "SecureString"
      value       = "testone:3306"
    },
    two = {
      name = "/database/two/endpoint"
      description = "Endpoint to connect to the two database"
      type        = "SecureString"
      value       = "testtwo:3306"
      }
    }
}

resource "aws_ssm_parameter" "endpoint" {
  for_each    = local.endpoints
  name        = each.value.name
  description = each.value.description
  type        = each.value.type
  value       = each.value.value
}




