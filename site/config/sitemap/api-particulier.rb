SitemapGenerator::Sitemap.default_host = "https://particulier.api.gouv.fr"
SitemapGenerator::Sitemap.sitemaps_path = "sitemaps/api-particulier"
SitemapGenerator::Sitemap.create do
  add api_particulier_stats_path

  add api_particulier_cas_usages_path

  APIParticulier::FichePratique.all.each do |fiche_pratique|
    add api_particulier_cas_usage_path(uid: fiche_pratique.uid)
  end
end
