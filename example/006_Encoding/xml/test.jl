using Pkg
Pkg.activate(".")

using LightXML

function save_xml(fn)
    xdoc = LightXML.XMLDocument()
    xroot = LightXML.create_root(xdoc, "Students")
    el = LightXML.new_child(xroot, "Student")
    LightXML.add_text(el, "Arick")
    LightXML.set_attribute(el, "sex", "1")
    LightXML.set_attributes(el, hp=100, mp=10)

    LightXML.save_file(xdoc, fn)
end

function load_xml(fn)
    xdoc = LightXML.parse_file(fn)
    xroot = LightXML.root(xdoc)
    for node in LightXML.child_nodes(xroot)
        if is_elementnode(node)
            el = XMLElement(node)
            println("sex=$(attribute(el, "sex"))")
            println("hp=$(attribute(el, "hp"))")
            println("Tag Name=$(name(el))")
            println("Text=$(content(node))")
        end
    end
    free(xdoc)
end

fn = "test.xml"
save_xml(fn)
load_xml(fn)

