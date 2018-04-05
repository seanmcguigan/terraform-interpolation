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



