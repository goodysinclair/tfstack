resource "aws_iam_policy" "policy" {
  name   = "${var.instance_name}-policy-${var.region}"
  path   = "/"
  policy = var.policy
}

resource "aws_iam_role" "service_role" {
  name               = "${var.instance_name}-${var.region}-service-role"
  assume_role_policy = var.assume_role_policy

  tags = merge(
    var.common_tags,
    { Name = "${var.instance_name}-${var.region}-service-role" }
  )
}

resource "aws_iam_role_policy_attachment" "attach" {
  count      = length(var.managed_policy_arn_list)
  policy_arn = var.managed_policy_arn_list[count.index]
  role       = aws_iam_role.service_role.name
}

resource "aws_iam_policy_attachment" "attach_cloudwatch_policy" {
  name       = "${var.instance_name} attach policy"
  policy_arn = aws_iam_policy.policy.arn
  roles      = [aws_iam_role.service_role.name]
}

resource "aws_iam_instance_profile" "instance_profile" {
  name = "${var.instance_name}-${var.region}-instance-profile"
  role = aws_iam_role.service_role.name
}

