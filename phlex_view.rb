class PhlexView < Phlex::HTML
  def initialize(context:)
    @context = context
  end

  def view_template
    html do
      head do
        title { "Simple Benchmark" }
      end
      body do
        h1 { @context.header }
        if @context.item.empty?
          p { "The list is empty." }
        else
          ul do
            @context.item.each do |i|
              if i[:current]
                li do
                  strong { i[:name] }
                end
              else
                li do
                  a(href: i[:url]) { i[:name] }
                end
              end
            end
          end
        end
      end
    end
  end
end
