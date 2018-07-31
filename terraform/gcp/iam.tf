resource "google_service_account" "account" {
  account_id   = "paasify-${var.env_name}"
  display_name = "Paasify ${var.env_name}"
}

resource "google_service_account_key" "key" {
  depends_on         = ["google_project_iam_member.admin"]
  service_account_id = "${google_service_account.account.name}"
}

resource "google_project_iam_member" "admin" {
  project = "${var.project}"
  role    = "roles/owner"
  member  = "serviceAccount:${google_service_account.account.email}"
}
