output "execution_role_arn" {
  value = aws_iam_role.execution.arn
}

output "task_role_arn" {
  value = aws_iam_role.task.arn
}

output "execution_policy_attachment_id" {
  value = aws_iam_role_policy_attachment.execution.id
}