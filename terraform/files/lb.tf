resource "google_compute_target_pool" "reddit-app" {
  name = "instance-pool"

  instances = [
    "${google_compute_instance.app.*.self_link}"
  ]

  health_checks = [
    "${google_compute_http_health_check.reddit-healthcheck.name}",
  ]
}

resource "google_compute_http_health_check" "reddit-healthcheck" {
  name               = "reddit-healthcheck"
  request_path       = "/"
  port               = "9292"
  check_interval_sec = 10
  timeout_sec        = 1
}

resource "google_compute_forwarding_rule" "reddit-pool" {
  name       = "reddit-pool"
  target     = "${google_compute_target_pool.reddit-app.self_link}"
  port_range = "9292"
}

