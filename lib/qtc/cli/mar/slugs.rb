require_relative 'base'

require 'yaml'
require 'fileutils'
require 'httpclient'
require 'net/http'

module Qtc
  module Cli
    class Mar::Slugs < Mar::Base

      def list(options)
        instance_id = resolve_instance_id(options)
        slugs = client.get("/apps/#{instance_id}/slugs/", {}, {'Authorization' => "Bearer #{current_cloud_token}"})
        if slugs && slugs['results'].size > 0
          template = "%-20.20s %-30.30s %-30.30s"
          puts template % ["TAG", "CREATED", "DEPLOYED"]
          slugs['results'].each do |slug|
            puts template % [slug['tag'], slug['createdAt'], slug['deployedAt']]
          end
        end
      end

      def remove(slug_id, options)
        instance_id = resolve_instance_id(options)
        client.delete("/apps/#{instance_id}/slugs/#{slug_id}", {}, {}, {'Authorization' => "Bearer #{current_cloud_token}"})
      end

      def upload(options)
        instance_id = resolve_instance_id(options)

        slug = create_slug(instance_id, options)
        upload_uri = URI(slug['blob']['url'])
        puts "Starting slug upload, if your slug is large this may take a while"
        # todo Would be nice to have some sort of progress indication...
        begin
          open(File.new(options.slug), 'rb') do |io|
            aws_client = Net::HTTP.new(upload_uri.host)
            req = Net::HTTP::Put.new(upload_uri.request_uri)
            req.content_length = io.size
            req.body_stream = io
            req['Content-Type'] = 'application/octet-stream'

            aws_client.request(req)
          end
        rescue => exc
          puts "Slug upload failed:#{exc.to_s}"
          raise StandardError "Slug upload failed!"
        end
        puts "Slug uploaded successfully, you may now deploy it using commit tag: #{slug['tag']}"
      end

      def deploy(slug_id, options)
        instance_id = resolve_instance_id(options)
        client.post("/apps/#{instance_id}/slugs/#{slug_id}/deploy", {}, {},  {'Authorization' => "Bearer #{current_cloud_token}"})
      end

      def create_slug(instance_id, options)
        process_types = resolve_proc_types(options)
        data = {
            tag: options.tag,
            process_types: process_types
        }
        client.post("/apps/#{instance_id}/slugs", data, {},  {'Authorization' => "Bearer #{current_cloud_token}"})
      end

      def resolve_proc_types(options)
        if options.procfile
          procfile_hash = {}
          procfile = YAML.load(File.read(options.procfile), :encoding => 'utf-8')
          procfile_hash.merge!(procfile) if procfile
          procfile_hash
        else
          raise StandardError 'Procfile must be given'
        end
      end
    end
  end
end

