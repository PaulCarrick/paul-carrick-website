module TrixEditorHelper
  def fill_in_trix_editor(id, with:)
    trix_editor = find("trix-editor##{id}") # This finds the `trix-editor` by its `id`
    page.execute_script("arguments[0].editor.insertString('#{with}')", trix_editor.native)
  end
end

