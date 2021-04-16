module Pexels
  class Client
    module SearchFilters
      ORIENTATIONS = %w(portrait landscape square).freeze
      SIZES = %w(small medium large).freeze
      COLORS = %w(red orange yellow green turquoise blue violet pink brown black gray white).freeze

      def validate_orientation(orientation)
        return true unless orientation
        return true if ORIENTATIONS.include?(orientation.to_s)

        raise ArgumentError, "`orientation` must be one of #{ORIENTATIONS.join(', ')}."
      end

      def validate_size(size)
        return true unless size
        return true if SIZES.include?(size.to_s)

        raise ArgumentError, "`size` must be one of #{SIZES.join(', ')}."
      end

      def validate_color(color)
        return true unless color
        return true if COLORS.include?(color.to_s)
        return true if color.to_s =~ /\A#?(?:[0-9a-f]{3}){1,2}\z/i

        raise ArgumentError, "`color` must be one of #{COLORS.join(', ')} or a valid hex code."
      end
    end
  end
end
