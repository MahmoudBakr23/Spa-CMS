ActiveAdmin.register Expense do
  # Role-based visibility
  menu if: proc { %w[admin secretary].include?(current_admin_user.role) }

  # Permitted fields
  permit_params :name, :amount, :occurred_on, :category, :notes, :trainer_id

  # Filters
  filter :name
  filter :amount
  filter :category, as: :select, collection: Expense::CATEGORIES
  filter :occurred_on
  filter :trainer

  # Index page
  index do
    selectable_column
    id_column
    column :name
    column :amount do |expense|
      number_to_currency expense.amount
    end
    column :occurred_on
    column :category
    column :trainer
    column :notes
    column :created_at
    actions
  end

  # Show page
  show do
    attributes_table do
      row :id
      row :name
      row :amount do
        number_to_currency expense.amount
      end
      row :occurred_on
      row :category
      row :trainer
      row :notes
      row :created_at
      row :updated_at
    end
  end

  # Form
  form do |f|
    f.inputs do
      f.input :trainer
      f.input :name
      f.input :amount
      f.input :occurred_on, as: :datepicker
      f.input :category, as: :select, collection: Expense::CATEGORIES
      f.input :notes
    end
    f.actions
  end
end
