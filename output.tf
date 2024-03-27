output "cluster_uri" {
  value = ovh_cloud_project_database.service.endpoints.0.uri
}

output "user_name" {
  value = ovh_cloud_project_database_mongodb_user.new_user.name
}

output "user_password" {
  value     = ovh_cloud_project_database_mongodb_user.new_user.password
  sensitive = true
}