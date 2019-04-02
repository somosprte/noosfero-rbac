module ActsAsSolr #:nodoc:

  module CommonMethods

    TypeMapping = {
      :double => "do",
      :float => "f",
      :decimal => "f",
      :integer => "i",
      :boolean => "b",
      :string => "s",
      :date => "d",
      :range_float => "rf",
      :range_integer => "ri",
      :facet => "facet",
      :text => "t",
      :ngram_text => "nt",
    }

    # Converts field types into Solr types
    def get_solr_field_type(field_type)
      if field_type.is_a?(Symbol)
        t = TypeMapping[field_type]
        raise "Unknown field_type symbol: #{field_type}" if t.nil?
        t
      elsif field_type.is_a?(String)
        return field_type
      else
        raise "Unknown field_type class: #{field_type.class}: #{field_type}"
      end
    end

    def solr_batch_add(objects)
      solr_add objects.map{ |a| a.to_solr_doc }
      solr_commit if defined?(configuration) and configuration[:auto_commit]
    end

    def solr_batch_add_association(ar, association)
      result = ar.send(association)
      result = [result] unless result.is_a?(Array)
      solr_batch_add result
    end

    # Sends an add command to Solr
    def solr_add(add_xml)
      ActsAsSolr::Post.execute(Solr::Request::AddDocument.new(add_xml))
    end

    # Sends the delete command to Solr
    def solr_delete(solr_ids)
      ActsAsSolr::Post.execute(Solr::Request::Delete.new(:id => solr_ids))
    end

    # Sends the commit command to Solr
    def solr_commit
      ActsAsSolr::Post.execute(Solr::Request::Commit.new)
    end

    # Optimizes the Solr index. Solr says:
    #
    # Optimizations can take nearly ten minutes to run.
    # We are presuming optimizations should be run once following large
    # batch-like updates to the collection and/or once a day.
    #
    # One of the solutions for this would be to create a cron job that
    # runs every day at midnight and optmizes the index:
    #   0 0 * * * /your_rails_dir/script/runner -e production "Model.solr_optimize"
    #
    def solr_optimize
      ActsAsSolr::Post.execute(Solr::Request::Optimize.new)
    end

    # Returns the id for the given instance
    def record_id object
      object.send object.class.primary_key
    end
  end
end
