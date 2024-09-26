output "dns_NS_record" {
  value = {
    name = google_dns_managed_zone.this.dns_name
    type = "NS"
    data = google_dns_managed_zone.this.name_servers
  }
}
