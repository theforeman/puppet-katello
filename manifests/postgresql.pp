class katello::postgresql(
  Hash[String, Any] $config_entries = {},
  Hash[String, Hash] $pg_hba_rules = {},
) {
  include ::postgresql::server

  $config_entries.each |$entry, $value| {
    postgresql::server::config_entry { $entry:
      value => $value,
    }
  }

  $pg_hba_rules.each |$rule_name, $rule| {
    postgresql::server::pg_hba_rule { $rule_name:
      * => $rule,
    }
  }
}
