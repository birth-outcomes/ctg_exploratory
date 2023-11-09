import matplotlib.pyplot as plt
from sklearn.metrics import (accuracy_score, classification_report,
                             confusion_matrix, roc_auc_score, roc_curve)
from sklearn.model_selection import GridSearchCV


def evaluate_model(model, features, target):
    pred = model.predict(features)
    acc = accuracy_score(target, pred)
    print("Accuracy:- %.2f%%" % (acc * 100.0))
    print('Confusion matrix :- \n', confusion_matrix(target, pred))
    print("Classification Report:-\n", classification_report(target, pred))


def plot_auc_roc(models, features, target):
    print("AUC ROC Scores")
    for model_name, model in models:
        pred = model.predict(features)
        score = roc_auc_score(target, pred)
        print(f"{model_name}: \t {score}")

        fpr, tpr, _ = roc_curve(target, pred)
        plt.plot(fpr, tpr, linestyle='--', label=model_name)

    plt.xlabel('False Positive Rate')
    plt.ylabel('True Positive Rate')
    plt.legend()
    plt.show()


def hyperparameter_tuning(model, parameters, X_train, y_train):

    grid = GridSearchCV(estimator=model, param_grid=parameters, cv=5,  n_jobs=5,
                        scoring='roc_auc', refit=True, verbose=1)

    grid.fit(X_train, y_train)
    print("Best Score (AUC ROC): {}".format(grid.best_score_*100))
    print("Best Parameters:", grid.best_params_)
    best_model = grid.best_estimator_
    return best_model

