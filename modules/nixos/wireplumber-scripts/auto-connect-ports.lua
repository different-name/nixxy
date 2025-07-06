-- based on https://github.com/bennetthardwick/dotfiles/blob/2463811c57c289733d390b6ef0a8d862b8c9c8ad/.config/wireplumber/scripts/auto-connect-ports.lua

function build_port_interest(subject, port, direction)
  return Interest({
    type = "port",
    Constraint({ subject, "equals", port }),
    Constraint({ "port.direction", "equals", direction }),
  })
end

function build_object_manager(subject, left_port, right_port, direction)
  return ObjectManager({
    build_port_interest(subject, left_port, direction),
    build_port_interest(subject, right_port, direction),
  })
end

function link_port(output_port, input_port)
  if not input_port or not output_port then
    return nil
  end

  local link_args = {
    ["link.input.node"] = input_port.properties["node.id"],
    ["link.input.port"] = input_port.properties["object.id"],

    ["link.output.node"] = output_port.properties["node.id"],
    ["link.output.port"] = output_port.properties["object.id"],

    -- The node never got created if it didn't have this field set to something
    ["object.id"] = nil,

    -- I was running into issues when I didn't have this set
    ["object.linger"] = true,

    ["node.description"] = "Link created by auto_connect_ports",
  }

  local link = Link("link-factory", link_args)
  link:activate(1)

  return link
end

function auto_connect_ports(args)
  local output_om =
    build_object_manager(args["output_subject"], args["output_left_port"], args["output_right_port"], "out")

  local input_om = build_object_manager(args["input_subject"], args["input_left_port"], args["input_right_port"], "in")

  local connect = {
    [args["output_left_port"]] = args["input_left_port"],
    [args["output_right_port"]] = args["input_right_port"],
  }

  local links = {}

  function _connect()
    for output_name, input_names_raw in pairs(connect) do
      local input_names = input_names_raw[1] == nil and { input_names_raw } or input_names_raw

      -- Iterate through all the output ports with the correct alias
      for output in output_om:iterate({ Constraint({ args.output_subject, "equals", output_name }) }) do
        for _i, input_name in pairs(input_names) do
          -- Iterate through all the input ports with the correct alias
          for input in input_om:iterate({ Constraint({ args.input_subject, "equals", input_name }) }) do
            -- Link all the nodes
            local link = link_port(output, input)

            if link then
              table.insert(links, link)
            end
          end
        end
      end
    end
  end

  output_om:connect("object-added", _connect)
  input_om:connect("object-added", _connect)

  output_om:activate()
  input_om:activate()
end
