# Contributing to Binary-Visualizer

We welcome contributions from the community! By following these guidelines, you can ensure your input is valuable and easily merged into the main project.

## 📝 How to Report Bugs

If you find a bug or issue, please use the GitHub **Issues** tab and follow these steps:

1.  **Check Existing Issues:** Ensure the bug has not already been reported.
2.  **Use the Bug Report Template:** Provide a clear and descriptive title.
3.  **Provide Details:** Include your **Delphi Version** (e.g., 10 Seattle), **Windows Version**, and steps to reproduce the bug.
4.  **Attach Screenshots (Optional):** Visual proof is always helpful.

## 💡 How to Suggest Enhancements

If you have an idea for a new feature, please open an issue with the label `enhancement`.

## 💻 Making Your Code Contribution (Pull Request)

1.  **Fork the Repository:** Create your own copy of the project.
2.  **Create a Branch:** Create a dedicated branch for your feature or bug fix (e.g., `feature/50mb-chunk-support` or `fix/crash-on-drag-drop`).
    ```bash
    git checkout -b your-new-branch-name
    ```
3.  **Set Up the Environment:**
    * You will need **Delphi 10 Seattle** or later.
    * Ensure the **Graphics32** library is installed and configured in your Delphi IDE's Library Path.
4.  **Code Changes:**
    * Follow standard Delphi naming conventions (e.g., `TMyObject`, `FInternalField`, `DoSomething`).
    * Keep your changes focused on one feature or fix per Pull Request.
5.  **Commit and Push:**
    * Write clear, concise commit messages (e.g., `Fix: Handle large files over 20MB correctly`).
    * Push your changes to your Fork.
6.  **Submit the Pull Request:** Open a Pull Request from your branch to the `main` branch of the original repository.

## 🏷️ Commit Message Guidelines

Please follow this simple structure for your commit messages:

* **`Feat:`** (New feature)
* **`Fix:`** (Bug fix)
* **`Chore:`** (Maintenance, build process changes, docs)
* **`Refactor:`** (Code cleanup without changing functionality)

*Example:* `Feat: Added support for a simple "Go To Offset" dialog.`
